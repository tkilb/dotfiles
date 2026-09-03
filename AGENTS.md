# AGENTS.md — ~/.dotfiles

Instructions for AI agents working in this repository.

## Purpose

This repo is the single source of truth for dotfiles, configs, and scripts
cross all of the user's machines (`linux-book`, `linux-box`, `pi-server`,
`steam-deck`, `work-book`). Files live here in per-tool subdirectories
(`nvim/`, `hypr/`, `kitty/`, `ai/`, etc.) and are deployed to their real
locations on disk (usually inside `$HOME`) as symlinks, not copies — so
editing a file at its real path and editing it in this repo are the same
operation once linked.

## How `linker/` works

- `linker/linker.yaml` is the manifest of every managed symlink. Each entry
  has:
  - `name` — identifier, also the default relative source path under
    `~/.dotfiles/` if `source` is omitted.
  - `source` — (optional) explicit path to the file/dir in this repo.
    Required whenever the destination should point at something _narrower_
    than the whole named directory (see `navi/AGENTS.md` for the canonical
    example of why this matters).
  - `path` — the real destination path (typically under `$HOME`) where the
    symlink is created.
  - `machines` — list of machine names this entry applies to; the entry is
    skipped on any machine not listed.
- Running `~/.local/bin/linker` (built from this dotfiles setup) walks the
  manifest, removes whatever currently exists at each `path` (file, dir, or
  stale symlink), and recreates it as a symlink to `source`.
- **Re-run `linker` after editing `linker.yaml`**, after cloning this repo
  fresh on a new machine, or after adding a new managed file — edits to
  files _already_ linked don't need a re-run.
- Multiple destinations can share one `source` (e.g. one `ai/AGENTS.md` file
  is currently symlinked to both Copilot's and Antigravity's global config
  locations) so shared config only needs to be maintained in one place.

## How `syncer/` works

- `syncer/syncer.yaml` defines a schedule (cron) for keeping this repo (and
  a handful of other repos, e.g. `alfred`, `dotfiles-work`) pulled/pushed on
  each machine, again scoped per-entry via `machines`.
- `syncer/syncer.log` and `syncer/state/` are runtime artifacts of that
  scheduled sync process — not hand-edited, safe to ignore when reviewing
  config changes.
- Syncer keeps the repo itself up to date across machines; linker keeps the
  _symlinks into_ the repo up to date on each machine. They're independent:
  changing `linker.yaml` doesn't require touching `syncer.yaml` and vice
  versa.

## How `ai/` works

- Holds shared, tool-agnostic AI agent configuration that multiple CLI
  agents (GitHub Copilot CLI, Google Antigravity CLI / `agy`) read from via
  `linker` symlinks, so there's one file to maintain instead of duplicating
  instructions/settings per tool:
  - `ai/AGENTS.md` — global agent instructions, symlinked to both
    `~/.copilot/copilot-instructions.md` (Copilot CLI's global instructions
    path) and `~/.gemini/GEMINI.md` (Antigravity's global rules path).
  - `ai/antigravity-settings.json` — Antigravity CLI's global permissions
    (`permissions.allow/ask/deny`), symlinked to
    `~/.gemini/antigravity-cli/settings.json`.
- Copilot CLI has no equivalent native _global_ permissions file (its
  `permissions-config.json` is scoped per-repository only) — global
  permission reduction for Copilot instead lives in the `copilot()` shell
  function in `zsh/.feature.ai.sh`, which wraps the real binary with
  `--allow-tool` flags.
- When adding a new shared/global AI config, prefer this pattern: put the
  real content under `ai/`, add a `linker.yaml` entry pointing at the
  tool's expected path, and re-run `linker`.
- `ai/ai-permissions-seed.json` + `ai/sync-ai-permissions.py` — a single,
  portable baseline of trusted directories/tools/domains for **both**
  agents, so there's one file to edit instead of duplicating trust
  decisions per tool:
  - `locations` — merged into Copilot CLI's live, per-machine
    `~/.copilot/permissions-config.json` (`tool_approvals` +
    `allowed_directories`).
  - `trusted_domains` — merged into Copilot CLI's live, per-machine
    `~/.copilot/settings.json` (`allowedUrls`) **and** into the
    git-tracked `ai/antigravity-settings.json` (as
    `read_url(<domain>)` allow entries).
  `~/.copilot/permissions-config.json` and `~/.copilot/settings.json` are
  **not** symlinked (see Gotchas below) because they also accumulate
  ephemeral, per-repo/per-session approvals that shouldn't sync across
  machines or pollute this repo's git history. Instead, edit the seed
  file, then re-run `ai/sync-ai-permissions.py` (add `--dry-run` to
  preview) to idempotently apply it — analogous to re-running `linker`
  after editing `linker.yaml`. This runs automatically (silent,
  idempotent, never blocks the launch) every time the `copilot()` wrapper
  in `zsh/.feature.ai.sh` is invoked, so no manual re-run is normally
  needed — just edit the seed and open a new `copilot` session.

## Gotchas

- Never assume a config file at its real path (e.g. `~/.copilot/settings.json`)
  is managed by `linker` — check `linker.yaml` first. Several real,
  non-symlinked config files (e.g. `~/.copilot/settings.json`,
  `~/.copilot/permissions-config.json`) intentionally live outside this
  repo because they're per-machine/local or not yet migrated.
- This repo is never committed to automatically — the user commits changes
  manually.
