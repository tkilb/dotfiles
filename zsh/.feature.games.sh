if [ "$MACHINE" = "linux-box" ]; then
  alias bs="$HOME/Programs/barony-saver/barony-saver.sh"
  alias doom="pkill -f moltengamepad ; cd $HOME/Programs/doom && npm start"
  alias molten='pkill -f moltengamepad ; moltengamepad -n 1'
  alias moltenc='nvim $HOME/.config/moltengamepad/profiles'
  alias proton-tricks='PROTON_VERSION="Proton Experimental" /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=protontricks com.github.Matoking.protontricks --no-term --gui'

  mode-d() {
    hyprctl keyword monitor "DP-1,auto"
    sleep 4
    hyprctl keyword monitor "DP-2,disable"
    pactl set-card-profile alsa_card.usb-EDIFIER_EDIFIER_G2000_EDI00000X07-01 output:iec958-stereo
    pactl set-default-sink alsa_output.usb-EDIFIER_EDIFIER_G2000_EDI00000X07-01.iec958-stereo
    echo "Display mode D: Normal monitor (DP-1) enabled, Ultrawide (DP-2) disabled"
    echo "EDIFIER G2000 set as default output"
  }

  mode-s() {
    hyprctl keyword monitor "DP-2,3840x1600@174.97Hz,0x0,1"
    sleep 4
    hyprctl keyword monitor "DP-1,disable"
    sleep 2
    hyprctl dispatch workspace 1
    pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
    echo "Display mode S: Ultrawide (DP-2) enabled, Normal monitor (DP-1) disabled"
    echo "Built-in analog set as default output"
  }
fi
