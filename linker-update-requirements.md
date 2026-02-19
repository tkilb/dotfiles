# Requirements

## Facts

- The current script is located at ~/.dotfiles/linker.sh
- The current config is located at ~/.dotfiles/linker.yaml

## Housekeeping

- Move the linker config to ~/.dotfiles/linker/linker.yaml
- Move the linker script to ~/.dotfiles/tools/linker/linker.sh
- Create a symlink from ~/.dotfiles/linker (actual) to ~/.config/linker (link)

## New Config Requirements

- Update the linker script to read from the new config location at ~/.config/linker/linker.yaml
- As a fallback, if the config is not found at the new location, check ~/.dotfiles/linker/linker.yaml
- When linker is run, have the linker script symlink itself to ~/.local/bin/linker for easier access, but only if it is not already symlinked there
