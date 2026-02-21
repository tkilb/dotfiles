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
elif [[ -f /etc/os-release && $(grep -Ei '^ID(_LIKE)?=.*debian' /etc/os-release) ]]; then
  OS="debian"
else
  echo "Unsupported OS. This script only supports MacOS, Arch and Debian."
  exit 1
fi

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
  elif [[ "$OS" == "debian" ]]; then
    sudo apt install ansible -y
  else
    brew install ansible
  fi
  echo "✓ Ansible installed"
fi
echo ""

# Create .ssh directory if it doesn't exist
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

if [[ -f ~/.ssh/id_rsa_personal-notes ]]; then
  echo "✓ SSH key id_rsa_personal-notes already exists"
else
  echo "Generating SSH key: id_rsa_personal-notes"
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_personal-notes -N ""
  KEYS_GENERATED=true
  echo "✓ SSH key id_rsa_personal-notes generated"
fi
echo ""

# Create SSH config
SSH_CONFIG=~/.ssh/config
if [[ -f "$SSH_CONFIG" ]]; then
  echo "✓ SSH config already exists"
  # Check if our config is already present
  if ! grep -q "Host github.com-personal-notes" "$SSH_CONFIG"; then
    echo "Adding GitHub configuration to existing SSH config..."
    cat >>"$SSH_CONFIG" <<'EOF'

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa

Host github.com-personal-notes
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal-notes
EOF
    echo "✓ GitHub configuration added to SSH config"
  fi
else
  echo "Creating SSH config..."
  cat >"$SSH_CONFIG" <<'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa

Host github.com-personal-notes
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal-notes
EOF
  chmod 600 "$SSH_CONFIG"
  echo "✓ SSH config created"
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

  # Try to upgrade to SSH if possible
  echo "Checking if SSH connection to GitHub is possible..."
  if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "SSH connection successful! Upgrading remote to SSH..."
    cd "$DOTFILES_DIR"
    git remote set-url origin git@github.com:tkilb/dotfiles.git
    echo "✓ Remote URL updated to SSH"
    cd - >/dev/null
  else
    echo "SSH connection not yet configured. Remote URL will remain HTTPS."
    echo "You can manually change it later with:"
    echo "  cd $DOTFILES_DIR && git remote set-url origin git@github.com:tkilb/dotfiles.git"
  fi
fi
echo ""

# Prompt for machine name
echo "Please enter a name for this machine (e.g., macbook-pro, work-laptop):"
read -r MACHINE_NAME

if [[ -n "$MACHINE_NAME" ]]; then
  # Add MACHINE variable to appropriate profile file
  if [[ "$OS" == "macos" ]]; then
    PROFILE_FILE=~/.zprofile
  else
    PROFILE_FILE=~/.profile
  fi

  if [[ -f "$PROFILE_FILE" ]] && grep -q "export MACHINE=" "$PROFILE_FILE"; then
    echo "✓ MACHINE variable already set in $PROFILE_FILE"
  else
    echo "export MACHINE=\"$MACHINE_NAME\"" >>"$PROFILE_FILE"
    echo "✓ MACHINE variable added to $PROFILE_FILE"
  fi

  export MACHINE="$MACHINE_NAME"
  echo "✓ MACHINE set to: $MACHINE_NAME"
else
  echo "⚠ No machine name provided. Skipping MACHINE variable setup."
fi
echo ""

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
echo ""
echo "Public key for id_rsa_personal-notes:"
cat ~/.ssh/id_rsa_personal-notes.pub
echo ""
echo "Add this key to your GitHub account at: https://github.com/settings/keys"
echo ""
echo "=================================="
echo "Bootstrap complete! 🎉"
echo "=================================="
