# AGENTS.md — ~/.dotfiles/herdr

Instructions for AI agents working in this directory.

## Purpose

Manages configuration and plugins for [Herdr](https://herdr.dev) (terminal workspace manager).

## Layout

- `config.toml` — primary Herdr configuration (theme, keybindings, pane settings, plugin action shortcuts).
- `plugins.yaml` — declarative manifest of community plugins installed on machines.
- `plugins/config/` — user configuration for specific plugins (e.g. `plugins/config/<plugin_id>/`).

## How Linker handles Herdr

- `linker/linker.yaml` links only `config.toml` (and `plugins/config/`) into `~/.config/herdr/`.
- `~/.config/herdr/` remains a normal local directory on each machine, holding local runtime state:
  - `plugins/github/` (plugin Git clones and compiled binaries)
  - `plugins.json` (local plugin registration index with machine-local absolute paths)
  - Sockets (`*.sock`), logs (`*.log`), and `session.json`
- These runtime files are never tracked in Git to avoid repository bloat and merge conflicts across machines.

## Installing Plugins

To sync configured plugins on a new machine:
```bash
herdr-tidy
```
Or directly via yq:
```bash
yq -r '.plugins[].repo' ~/.dotfiles/herdr/plugins.yaml | xargs -n1 herdr plugin install
```
