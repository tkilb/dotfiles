# Dotfiles

## Arch Linux Installation

To install Arch Linux using the provided `archinstall.json` configuration:

### Increase Font Size if Necessary

```sh
setfont -d
```

```sh
archinstall --config-url https://raw.githubusercontent.com/tkilb/dotfiles/main/archinstall.json
```

## Post-Installation Bootstrap

Run the bootstrap script directly without cloning:

```sh
curl -fsSL https://raw.githubusercontent.com/tkilb/dotfiles/main/bootstrap.sh | bash
```

## Arch ISO Minimal Network Configuration on Wifi

```sh
iwctl

station wlan0 show
station wlan0 scan
station wlan0 connect <SSID>

quit
```

### Update GPG Keys

```sh
pacman-key --init
pacman-key --populate archlinux
```
