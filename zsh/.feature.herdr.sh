##################################################
# Herdr Workspace Manager Helpers
##################################################

# Tidy/sync Herdr plugins based on ~/.dotfiles/herdr/plugins.yaml
herdr-tidy() {
  "$HOME/.dotfiles/tools/herdr/herdr-tidy.sh" "$@"
}

# Herdr hides KITTY_WINDOW_ID and sets TERM_PROGRAM=herdr, so para cannot detect
# kitty graphics support and falls back to blurry half-block images.
[[ -n "$HERDR_ENV" ]] && export PARA_IMAGE_PROTOCOL=kitty
