#!/bin/bash
set -e

echo "=================================="
echo "Bootstrap Script for New Machine"
echo "=================================="
echo ""

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
elif [[ -f /etc/arch-release ]]; then
  OS="arch"
elif [[ -f /etc/fedora-release ]]; then
  OS="fedora"
elif [[ -f /etc/os-release && $(grep -Ei '^ID(_LIKE)?=.*debian' /etc/os-release) ]]; then
  OS="debian"
else
  echo "Unsupported OS. This script only supports MacOS, Arch, Fedora, and Debian."
  exit 1
fi

# Install Git
if command -v git &>/dev/null; then
  echo "✓ Git is already installed"
else
  echo "Installing Git..."
  if [[ "$OS" == "arch" ]]; then
    sudo pacman -S --noconfirm git
  elif [[ "$OS" == "fedora" ]]; then
    sudo dnf install -y git
  elif [[ "$OS" == "debian" ]]; then
    sudo apt install git -y
  else
    brew install git
  fi
  echo "✓ Git installed"
fi
echo ""

# Set global git merge strategy to rebase
echo "Setting global git merge strategy to rebase..."
git config --global pull.rebase true
echo "✓ Global git merge strategy set to rebase"
echo ""

echo "Detected OS: $OS"
echo ""

# Install Homebrew (MacOS only)
if [[ "$OS" == "macos" ]]; then
  if command -v brew &>/dev/null; then
    echo "✓ Homebrew is already installed"
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "✓ Homebrew installed"
  fi
  echo ""
fi

# Install Ansible
if command -v ansible &>/dev/null; then
  echo "✓ Ansible is already installed"
else
  echo "Installing Ansible..."
  if [[ "$OS" == "arch" ]]; then
    sudo pacman -S --noconfirm ansible
  elif [[ "$OS" == "fedora" ]]; then
    sudo dnf install -y ansible
  elif [[ "$OS" == "debian" ]]; then
    sudo apt install ansible -y
  else
    brew install ansible
  fi
  echo "✓ Ansible installed"
fi

# Remove default .ansible directory if it is not a symlink
if [[ -d "$HOME/.ansible" ]] && [[ ! -L "$HOME/.ansible" ]]; then
  rm -rf "$HOME/.ansible"
  echo "✓ Default .ansible directory removed"
fi
echo ""

# Install Zsh
if command -v zsh &>/dev/null; then
  echo "✓ Zsh is already installed"
else
  echo "Installing Zsh..."
  if [[ "$OS" == "arch" ]]; then
    sudo pacman -S --noconfirm zsh
  elif [[ "$OS" == "fedora" ]]; then
    sudo dnf install -y zsh
  elif [[ "$OS" == "debian" ]]; then
    sudo apt install zsh -y
  else
    brew install zsh
  fi
  echo "✓ Zsh installed"
fi
echo ""

# Install Oh My Zsh
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "✓ Oh My Zsh is already installed"
else
  echo "Installing Oh My Zsh..."
  CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "✓ Oh My Zsh installed"
fi
echo ""

# Symlink .zshrc
echo "Symlinking .zshrc..."
if [[ -L "$HOME/.zshrc" ]]; then
  echo "✓ .zshrc is already a symlink"
else
  # Back up existing .zshrc if it is a regular file
  if [[ -f "$HOME/.zshrc" ]]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.pre-bootstrap"
    echo "✓ Existing .zshrc backed up to .zshrc.pre-bootstrap"
  fi
  ln -sf "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.zshrc"
  echo "✓ .zshrc symlinked to ~/.dotfiles/zsh/.zshrc"
fi
echo ""

# Set Zsh as default shell
if [[ "$(basename "$SHELL")" == "zsh" ]]; then
  echo "✓ Zsh is already the default shell"
else
  echo "Setting Zsh as default shell..."
  sudo chsh -s "$(which zsh)" "$USER"
  echo "✓ Zsh set as default shell. Please log out and back in for changes to take effect."
fi
echo ""

# Install OpenSSH
if command -v ssh &>/dev/null; then
  echo "✓ OpenSSH is already installed"
else
  echo "Installing OpenSSH..."
  if [[ "$OS" == "arch" ]]; then
    sudo pacman -S --noconfirm openssh
  elif [[ "$OS" == "fedora" ]]; then
    sudo dnf install -y openssh-clients
  elif [[ "$OS" == "debian" ]]; then
    sudo apt install openssh-client -y
  fi
  echo "✓ OpenSSH installed"
fi
echo ""

# Install yay (Arch Linux only)
if [[ "$OS" == "arch" ]]; then
  if command -v yay &>/dev/null; then
    echo "✓ yay is already installed"
  else
    echo "Installing yay..."
    sudo pacman -S --noconfirm --needed git base-devel
    YAY_TMP=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$YAY_TMP"
    # makepkg cannot be run as root, so we run it as the current user
    (cd "$YAY_TMP" && makepkg -si --noconfirm)
    rm -rf "$YAY_TMP"
    echo "✓ yay installed"
  fi
  echo ""
fi

# Set global git user name and email
if ! git config --global user.name >/dev/null; then
  echo "Please enter your Git name:"
  read -r GIT_NAME </dev/tty
  if [[ -n "$GIT_NAME" ]]; then
    git config --global user.name "$GIT_NAME"
    echo "✓ Git name set to: $GIT_NAME"
  fi
fi

if ! git config --global user.email >/dev/null; then
  echo "Please enter your Git email:"
  read -r GIT_EMAIL </dev/tty
  if [[ -n "$GIT_EMAIL" ]]; then
    git config --global user.email "$GIT_EMAIL"
    echo "✓ Git email set to: $GIT_EMAIL"
  fi
fi

# Create .ssh directory if it does not exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate SSH keys
echo "Setting up SSH keys..."
KEYS_GENERATED=false

if [[ -f ~/.ssh/id_rsa ]]; then
  echo "✓ SSH key id_rsa already exists"
else
  echo "Generating SSH key: id_rsa"
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
  KEYS_GENERATED=true
  echo "✓ SSH key id_rsa generated"
fi
echo ""

# Create SSH config
SSH_CONFIG=~/.ssh/config
if [[ -f "$SSH_CONFIG" ]]; then
  echo "✓ SSH config already exists"
else
  if [[ -f ~/.ssh/id_rsa ]]; then
    echo "Creating SSH config..."
    echo "Host github.com" >"$SSH_CONFIG"
    echo "    HostName github.com" >>"$SSH_CONFIG"
    echo "    User git" >>"$SSH_CONFIG"
    echo "    IdentityFile ~/.ssh/id_rsa" >>"$SSH_CONFIG"
    chmod 600 "$SSH_CONFIG"
    echo "✓ SSH config created"
  else
    echo "⚠ SSH key not found, skipping SSH config creation"
  fi
fi
echo ""

# Clone dotfiles repository
DOTFILES_DIR=~/.dotfiles
if [[ -d "$DOTFILES_DIR" ]]; then
  echo "✓ Dotfiles repository already exists at $DOTFILES_DIR"
else
  echo "Cloning dotfiles repository..."
  git clone https://github.com/tkilb/dotfiles "$DOTFILES_DIR"
  echo "✓ Dotfiles repository cloned"
fi

# Try to upgrade to SSH if possible
echo "Checking if SSH connection to GitHub is possible..."
if ssh -T git@github.com 2>&1 | grep -qE "(successfully authenticated|Hi .+! You've successfully authenticated)"; then
  echo "SSH connection successful! Upgrading remote to SSH..."
  cd "$DOTFILES_DIR"
  git remote set-url origin git@github.com:tkilb/dotfiles.git
  echo "✓ Remote URL updated to SSH"
  cd - >/dev/null 2>&1
else
  echo "SSH connection not yet configured. Remote URL will remain HTTPS."
  echo "You can manually change it later with:"
  echo "  cd $DOTFILES_DIR && git remote set-url origin git@github.com:tkilb/dotfiles.git"
fi
echo ""

# Create local bin directory and symlink tools
mkdir -p "$HOME/.local/bin"
echo "Symlinking linker to ~/.local/bin/linker..."
ln -sf "$DOTFILES_DIR/tools/linker/linker.sh" "$HOME/.local/bin/linker"
echo "✓ linker symlinked"
echo "Symlinking syncer to ~/.local/bin/syncer..."
ln -sf "$DOTFILES_DIR/tools/syncer/syncer.sh" "$HOME/.local/bin/syncer"
echo "✓ syncer symlinked"
echo ""

# Create standard workspace directories
echo "Creating workspace directories..."
mkdir -p ~/General ~/Staging ~/Scratch ~/Spike
echo "✓ Workspace directories created"
echo ""

# Prompt for machine name only if ~/.profile is empty or MACHINE is not set
if
  [[ ! -s ~/.profile ]] || ! grep -q "export MACHINE=" ~/.profile 2>/dev/null
then
  echo "Please enter a name for this machine:"
  read -r MACHINE_NAME

  if [[ -n "$MACHINE_NAME" ]]; then
    # Ensure ~/.profile ends with a newline before appending
    if [[ -s ~/.profile ]] && [[ "$(tail -c1 ~/.profile | wc -l)" -eq 0 ]]; then
      echo "" >> ~/.profile
    fi
    echo "export MACHINE=\"$MACHINE_NAME\"" >>~/.profile
    echo "✓ MACHINE variable added to ~/.profile"
    export MACHINE="$MACHINE_NAME"
    echo "✓ MACHINE set to: $MACHINE_NAME"
  else
    echo "⚠ No machine name provided. Skipping MACHINE variable setup."
  fi
fi

# Display public keys
echo "=================================="
echo "SSH Keys Setup Complete!"
echo "=================================="
echo ""
echo "Public key for id_rsa:"
if [[ "$OS" == "macos" ]]; then
  cat ~/.ssh/id_rsa.pub | pbcopy
  echo "(Copied to clipboard)"
else
  cat ~/.ssh/id_rsa.pub
fi
echo ""
echo "Add this key to your GitHub account at: https://github.com/settings/keys"
echo ""
echo "=================================="
echo "BOOTSTRAP COMPLETE"
echo "=================================="
