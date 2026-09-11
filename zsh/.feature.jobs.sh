
##################################################
# fancy-ctrl-z: toggle between the two most recent jobs
##################################################
# Custom (not oh-my-zsh's fancy-ctrl-z plugin): that plugin submits plain
# `fg` on an empty prompt, which only resumes the *current* job (%+/%%) -
# i.e. whatever you just suspended. It can't toggle back and forth between
# two jobs. This version uses `fg %-` (the *previous* job) instead, so
# Ctrl-Z at an idle prompt swaps you to the other of the two most recently
# suspended jobs each time.
#
# When a foreground program is actually running, Ctrl-Z is caught by the
# tty driver (SIGTSTP) before zle ever sees it, so this widget only fires
# at an idle/empty prompt - normal suspend behavior is unaffected.
fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg %- 2>/dev/null
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
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
