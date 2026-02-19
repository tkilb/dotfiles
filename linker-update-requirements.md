# Requirements

## Facts

- The current script is located at ~/.dotfiles/linker.sh
- The current config is located at ~/.dotfiles/linker.yaml

## Housekeeping

- Move the linker config to ~/.config/linker/linker.yaml
- Move the linker script to ~/.dotfiles/tools/linker.sh
- Create a symlink from ~/.dotfiles/linker to ~/.config/linker

## New Config Requirements

- Update the linker script to read from the new config location
- As a fallback, if the config is not found at the new location, check ./dotfiles/linker/linker.yaml
