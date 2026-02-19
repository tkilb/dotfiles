# Requirements

## Facts

- The current script is located at ~/.dotfiles/tools/syncer/syncer.sh
- The current config is located at ~/.dotfiles/syncer/syncer.yaml

## Housekeeping

- Create a symlink from ~/.dotfiles/syncer (actual) to ~/.config/syncer (link)
- Check the script for pathing errors as the config location has changed

## New Config Requirements

- Update the syncer script to read from the new config location at ~/.config/syncer/syncer.yaml
- When syncer is run, have the syncer script symlink itself to ~/.local/bin/syncer for easier access, but only if it is not already symlinked there
