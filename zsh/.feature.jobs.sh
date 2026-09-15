
##################################################
# fancy-ctrl-z: round-robin through all suspended jobs
##################################################
# Custom (not oh-my-zsh's fancy-ctrl-z plugin): that plugin submits plain
# `fg` on an empty prompt, which only resumes the *current* job (%+/%%) -
# i.e. whatever you just suspended. zsh's own %+/%- pair is likewise only a
# 2-slot memory (current/previous), so a naive `fg %-` toggle works fine
# with exactly two suspended jobs but gets "stuck" oscillating between the
# last two once a third (e.g. yazi, vim, copilot all suspended at once) is
# in the mix - there's no built-in way to cycle back to the oldest one.
#
# This version tracks its own FIFO queue of suspended jobs (by job
# number, kept in sync via a precmd hook every time you're back at an
# idle prompt) and resumes whichever one has been waiting longest, so
# repeated Ctrl-Z presses cycle through *all* suspended jobs in turn
# instead of just flip-flopping between two.
#
# Job numbers (the keys of $jobstates) are stable for a job's whole
# lifetime - including while it's suspended - so there's no need to
# track anything fancier like PIDs; the number itself is the identity we
# want.
#
# When a foreground program is actually running, Ctrl-Z is caught by the
# tty driver (SIGTSTP) before zle ever sees it, so this widget only fires
# at an idle/empty prompt - normal suspend behavior is unaffected.
typeset -ga _ctrlz_queue

# Keep $_ctrlz_queue in sync with reality: add any newly-suspended job's
# number to the back of the queue, drop any job that's no longer
# suspended (resumed or exited). Runs every time we're back at an idle
# prompt, which covers both "I just suspended something" and "I just
# resumed something" - so a resumed-then-resuspended job naturally
# reappears at the back of the queue instead of needing manual rotation.
_ctrlz_sync_queue() {
  local jn
  local -a live
  for jn in ${(kn)jobstates}; do
    [[ ${jobstates[$jn]%%:*} == suspended ]] || continue
    live+=("$jn")
    (( ${_ctrlz_queue[(Ie)$jn]} )) || _ctrlz_queue+=("$jn")
  done
  local -a kept
  local j
  for j in "${_ctrlz_queue[@]}"; do
    (( ${live[(Ie)$j]} )) && kept+=("$j")
  done
  _ctrlz_queue=("${kept[@]}")
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _ctrlz_sync_queue

fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    _fancy_ctrl_z_fg
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
}

_fancy_ctrl_z_fg() {
  _ctrlz_sync_queue
  (( ${#_ctrlz_queue} == 0 )) && return

  # Resume whichever suspended job has been waiting longest (front of
  # the queue).
  local jn=${_ctrlz_queue[1]}

  # Some TUI programs (lazygit in particular - see
  # https://github.com/jesseduffield/lazygit/issues/3937 and #4320) race
  # to write to the tty right after being resumed, before they actually
  # own the terminal's foreground process group. If `stty tostop` is in
  # effect, the kernel responds by re-stopping them with SIGTTOU/SIGTTIN
  # ("suspended (tty output/input)") instead of letting them run, so a
  # plain `fg` appears to silently do nothing. Detect that specific state
  # and retry a few times; the race window is normally only a few ms.
  # Deliberately does NOT retry on a plain "...=suspended" state, since
  # that just means the user hit Ctrl-Z again on purpose to re-suspend.
  local tries=0
  while (( tries++ < 5 )); do
    fg "%$jn" 2>/dev/null
    [[ "${jobstates[$jn]:-}" == *'suspended (tty '* ]] || break
    sleep 0.05
  done
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

##################################################
# jobs override: fix blank command text for jobs
# started inside shell functions (vim, copilot, y, etc.)
##################################################
# Known zsh limitation: when a job's foreground/background command is
# invoked from *inside a shell function* (as opposed to typed directly
# at the prompt), zsh's builtin `jobs` printer loses the job's command
# text and shows a blank field after "suspended"/"running" - even though
# the text is still correctly cached in the `$jobtexts` associative
# array. This affects any wrapper function (vim -> nvim, copilot ->
# command copilot, y -> yazi, etc.), regardless of where the wrapped
# command appears in the function body.
# Ref: https://unix.stackexchange.com/questions/725019
#
# Fix: override `jobs` (no-arg / default form) to render its own listing
# sourced directly from $jobstates + $jobtexts, which are always correct.
# Any other invocation (flags like -p, -z, etc.) falls through to the
# real builtin unchanged.
jobs() {
  if [[ $# -gt 0 ]]; then
    builtin jobs "$@"
    return $?
  fi

  local jn entry st mark pid rest
  for jn in ${(kn)jobstates}; do
    entry=${jobstates[$jn]}
    st=${entry%%:*}
    rest=${entry#*:}
    mark=${rest%%:*}
    pid=${rest#*:}
    pid=${pid%%=*}
    printf '[%d]  %-1s %-6d %-12s %s\n' "$jn" "$mark" "$pid" "$st" "${jobtexts[$jn]:-<unknown>}"
  done
}

##################################################
# j: fzf-driven picker for the builtin job table
##################################################
# fg/bg/kill on a job spec (%n) only work when invoked directly by the
# *current* interactive shell - they can't be run from a process fzf
# forks off (its --bind execute() actions run in a detached subshell,
# which is not part of this shell's job control). So fzf here is used
# purely to pick a job + capture which key confirmed the choice (via
# --expect); the actual fg/bg/kill call happens back in this function,
# i.e. in the real interactive shell.
#
# Keybinds: Enter = fg | Ctrl-B = bg | Ctrl-K = kill (SIGTERM)
j() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "jobs: fzf is required but not found in PATH" >&2
    return 1
  fi

  # NOTE: deliberately not `joblist=$(jobs)` - command substitution forks a
  # subshell, and a forked subshell's $jobstates/$jobtexts start out empty
  # (job control is tied to this shell instance, not inherited by the
  # subshell fork), so `jobs` would wrongly report no jobs at all. Routing
  # through a temp file keeps `jobs` running directly in this shell.
  local joblist tmpf
  tmpf=$(mktemp)
  jobs > "$tmpf"
  joblist=$(<"$tmpf")
  rm -f "$tmpf"
  if [[ -z "$joblist" ]]; then
    echo "jobs: no background/suspended jobs"
    return 0
  fi

  local out key selection jobnum
  out=$(fzf \
    --prompt="job> " \
    --header="Enter: fg   Ctrl-B: bg   Ctrl-K: kill" \
    --expect=ctrl-b,ctrl-k <<< "$joblist")

  [[ -z "$out" ]] && return 0

  key=$(head -n1 <<< "$out")
  selection=$(sed -n '2p' <<< "$out")
  [[ -z "$selection" ]] && return 0

  jobnum=${selection#\[}
  jobnum=${jobnum%%\]*}
  if [[ -z "$jobnum" || ! "$jobnum" =~ ^[0-9]+$ ]]; then
    echo "jobs: could not parse job number from selection: $selection" >&2
    return 1
  fi

  case "$key" in
    ctrl-b)
      bg "%$jobnum"
      ;;
    ctrl-k)
      # A *suspended* (stopped) job won't die from a plain SIGTERM - POSIX
      # doesn't deliver signals to a stopped process, so the signal just
      # sits pending and the job lingers (nagging zsh's exit-time
      # "you have suspended jobs" check). Resume it first so SIGTERM can
      # actually be delivered, then terminate it.
      local jobstatus
      jobstatus=$(awk '{print $4}' <<< "$selection")
      if [[ "$jobstatus" == suspended* ]]; then
        kill -CONT "%$jobnum" 2>/dev/null
        kill -TERM "%$jobnum" && echo "jobs: resumed + sent SIGTERM to %$jobnum (was suspended)"
      else
        kill "%$jobnum" && echo "jobs: sent SIGTERM to %$jobnum"
      fi

      # Some processes (TUI apps like nvim/vim in particular) either trap
      # SIGTERM to do their own cleanup, or - if they're not actually in
      # the terminal's foreground process group - get re-stopped by
      # SIGTTOU the moment they try to write cleanup escape codes to the
      # tty. Either way they can linger in the job table looking "done" to
      # us but never actually exiting. Give it a brief grace period, then
      # escalate to SIGKILL (which can't be trapped or deferred) if it's
      # still there.
      local waited=0
      while (( waited < 10 )) && (( ${+jobstates[$jobnum]} )); do
        sleep 0.1
        (( waited++ ))
      done
      if (( ${+jobstates[$jobnum]} )); then
        kill -KILL "%$jobnum" 2>/dev/null && echo "jobs: %$jobnum didn't exit gracefully, sent SIGKILL"
      fi
      ;;
    *)
      fg "%$jobnum"
      ;;
  esac
}
