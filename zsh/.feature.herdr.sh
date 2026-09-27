##################################################
# Herdr Workspace Manager Helpers
##################################################

# Tidy/sync Herdr plugins based on ~/.dotfiles/herdr/plugins.yaml
herdr-tidy() {
  "$HOME/.dotfiles/tools/herdr/herdr-tidy.sh" "$@"
}
