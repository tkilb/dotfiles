# navi

Cheatsheets for [navi](https://github.com/denisidoro/navi), an interactive
command-line cheatsheet tool. Browse, fuzzy-search, and run saved commands
with fill-in-the-blank `<placeholders>`.

## Layout

Cheatsheets live in `cheats/`, one subfolder per topic (following navi's
featured-repo convention), and are symlinked (via `linker`) to navi's data
directory at `~/.local/share/navi/cheats`.

## Usage

```sh
navi            # open the interactive cheatsheet browser
```

## Adding cheats

Add or edit `.cheat` files under `cheats/<topic>/`. Syntax reference:
https://github.com/denisidoro/navi/blob/master/docs/cheatsheet/syntax/README.md

## Current cheatsheets

- `zip/zip.cheat` — zip/unzip command snippets
- `find/find.cheat` — find command snippets
- `ls/ls.cheat` — ls command snippets
- `tar/tar.cheat` — tar archive command snippets
- `rsync/rsync.cheat` — rsync command snippets (including NAS-safe sync)
- `runbook/nerd-fonts.cheat` — Nerd Fonts install runbook (Arch Linux)
