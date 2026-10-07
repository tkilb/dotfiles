# AGENTS.md — ~/.dotfiles

Instructions for AI agents working in this repository.

## Purpose

Single source of truth for dotfiles, configs, and scripts across all machines
(`linux-book`, `linux-box`, `pi-server`, `steam-deck`, `work-book`). Files live
in per-tool subdirectories (`nvim/`, `hypr/`, `kitty/`, `ai/`, etc.) and are
deployed as symlinks, not copies — editing a file at its real path or in this
repo is the same operation once linked.

## Portability

Primary targets are **Arch Linux** and **macOS** — changes must work on both.
Debian support is appreciated but secondary: add Debian-specific handling
only when it's trivial (e.g. a different package name or an existing repo)
and never let it block, complicate, or water down an Arch/macOS change.

## `linker/`

- `linker/linker.yaml` manifests every managed symlink: `name` (id, default
  source path under `~/.dotfiles/`), `source` (optional explicit path,
  required when the destination should be narrower than the whole named
  dir — see `navi/AGENTS.md`), `path` (real destination, usually under
  `$HOME`), `machines` (which machines the entry applies to).
- `~/.local/bin/linker` walks the manifest and replaces whatever's at each
  `path` with a symlink to `source`.
- Re-run `linker` after editing `linker.yaml`, cloning fresh, or adding a
  managed file — edits to already-linked files don't need a re-run.
- One `source` can back multiple destinations (e.g. `ai/AGENTS.md` links to
  both Copilot's and Antigravity's global config paths).

## `syncer/`

- `syncer/syncer.yaml` schedules (cron) pull/push for this repo and a few
  others (`alfred`, `dotfiles-work`), scoped per-entry via `machines`.
- `syncer/syncer.log` and `syncer/state/` are runtime artifacts — ignore
  when reviewing config changes.
- Independent from linker: syncer keeps the repo itself updated across
  machines; linker keeps symlinks into the repo updated on each machine.

## `ai/`

Shared, tool-agnostic AI agent config read by multiple CLI agents (GitHub
Copilot CLI, Antigravity CLI) via `linker` symlinks — one file to maintain
instead of per-tool duplicates.

- `ai/AGENTS.md` — global agent instructions, symlinked to
  `~/.copilot/copilot-instructions.md` and `~/.gemini/GEMINI.md`.
- `ai/antigravity-settings.json` — Antigravity's global permissions,
  symlinked to `~/.gemini/antigravity-cli/settings.json`.
- Copilot has no native global permissions file; global permission
  reduction instead lives in the `copilot()` shell function in
  `zsh/.feature.ai.sh`, which wraps the binary with `--allow-tool` flags.
- `ai/ai-permissions-seed.json` + `ai/sync-ai-permissions.py` — one portable
  baseline of trusted directories/tools/domains for both agents:
  - `locations` → merged into Copilot's `~/.copilot/permissions-config.json`.
  - `trusted_domains` → merged into Copilot's `~/.copilot/settings.json`
    (`allowedUrls`) and into `ai/antigravity-settings.json`.
  - Those two Copilot files are **not** symlinked (see Gotchas) — they also
    accumulate ephemeral per-repo/session state. Edit the seed, then
    re-run `sync-ai-permissions.py` (`--dry-run` to preview). This also
    runs automatically, silently, on every `copilot` launch via the
    `copilot()` wrapper.
- Adding new shared/global AI config: put the real file under `ai/`, add a
  `linker.yaml` entry, re-run `linker`.

## Gotchas

- Don't assume a config file at its real path is managed by `linker` —
  check `linker.yaml` first. `~/.copilot/settings.json` and
  `~/.copilot/permissions-config.json` intentionally live outside this
  repo (per-machine/local, not yet migrated).
- This repo is never committed to automatically — the user commits
  manually.
