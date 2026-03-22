# Dotfiles

## Dotfiles Bootstrap

```sh
curl -fsSL https://raw.githubusercontent.com/tkilb/dotfiles/main/bootstrap.sh | bash
```

## Arch Linux Installation

### Network Configuration on Wifi

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

### Arch Install

```sh
archinstall --config-url https://raw.githubusercontent.com/tkilb/dotfiles/main/archinstall.json
```

## Post-Installation

### Increase Font Size if Necessary

```sh
setfont -d
```

### Network Configuration on Wifi

```sh
nmcli device wifi connect <SSID>
```
