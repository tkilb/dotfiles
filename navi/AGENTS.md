# AGENTS.md — navi cheatsheets

Instructions for AI agents working in this directory.

## Layout

- `cheats/<topic>/*.cheat` — one subfolder per topic (matches navi's
  featured-repo convention, e.g. `denisidoro/cheats`). Filenames within a
  topic folder don't need to be `main.cheat` — any `*.cheat` file is loaded.
- Runbook-style entries pair a `.cheat` file with a plain `.md` file
  (e.g. `runbook/nerd-fonts.cheat` + `runbook/nerd-fonts.md`). The `.cheat`
  entry just opens the `.md` file in `$EDITOR` — navi is not a real
  sequential-runbook executor, so don't try to encode multi-step logic
  directly in the `.cheat` command.

## Gotchas (things that broke before)

- **Linker source override is required.** The `linker.yaml` entry for this
  directory must set `source: ~/.dotfiles/navi/cheats` explicitly. The
  linker tool's default source is `~/.dotfiles/<name>` (i.e. `~/.dotfiles/navi`
  here), which would symlink the whole `navi/` folder — including this
  `AGENTS.md` and `README.md` — into navi's data dir instead of just
  `cheats/`.
- **Do not use `${VAR:-default}` shell parameter expansion inside `.cheat`
  command lines.** navi's parser silently fails to load the entire file if
  it's present (no error shown — the cheat just doesn't appear in search).
  Use plain `"$VAR"` instead (e.g. `"$EDITOR"` rather than
  `${EDITOR:-vim}`).
- After adding/editing cheats, verify with `navi` interactively — there is
  no reliable non-interactive/headless way to list all loaded cheats to
  confirm a file parsed correctly, since `navi --print --best-match` opens
  an interactive fzf prompt whenever more than one candidate matches (and
  produces no distinguishable output when zero candidates match vs. when a
  match requires interactive confirmation).

## After changes

Run the `linker` tool to (re)apply symlinks if `linker.yaml` itself changed,
or after cloning fresh. Regular edits to files already inside `cheats/`
don't require re-linking (they're already exposed via the existing symlink).
