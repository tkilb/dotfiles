if [ "$MACHINE" = "linux-box" ]; then
    alias bs="$HOME/Programs/barony-saver/barony-saver.sh"
    alias doom="pkill -f moltengamepad ; cd $HOME/Programs/doom && npm start"
    alias molten='pkill -f moltengamepad ; moltengamepad -n 1'
    alias moltenc='nvim $HOME/.config/moltengamepad'
    alias proton-tricks='PROTON_VERSION="Proton Experimental" /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=protontricks com.github.Matoking.protontricks --no-term --gui'
fi
