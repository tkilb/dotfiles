# Requirements for Bootstrap Script

## Requirements

- This will be a bash script that runs on a Arch Linux or MacOS system.
- This script will create a bootstrap.sh in this current directory.
- The bootstrap.sh will contain the necessary commands to setup a few basic tools to get started on a new machine.
- It will install the following tools:
  - Brew for (MacOS)
  - Ansible (Using pacman for Arch Linux and brew for MacOS)
- It setup rsa keys using the following commands

```sh
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_personal-notes -N ""
```

- It will create a .ssh/config file with the following content:

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa

Host github.com-personal-notes
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal-notes
```

- It will echo the public keys to the terminal, id_rsa will be copied to the clipboard using pbcopy. At the very end of the script, it will print the public key for id_rsa_personal-notes to the terminal so the user can copy it and add it to their github account.
- If the script is run multiple times, it should check if the keys already exist before trying to create them again. If the keys already exist, it should skip the key generation step and just print the public keys to the terminal.

```
echo "Public key for id_rsa:"
cat ~/.ssh/id_rsa.pub | pbcopy
echo "Public key for id_rsa_personal-notes:"
cat ~/.ssh/id_rsa_personal-notes.pub
```

- It will clone the public dotfile repository https://github.com/tkilb/dotfiles and store in ~/.dotfiles using https
- If cloning with ssh is possible, it will use the ssh url instead of https and replace the remote url with the ssh url.
- The script should be able to run multiple times without causing issues, meaning it should check if the tools are already installed and if the keys already exist before trying to create them again.
- Not part of the script, but add to the readme the curl command to run the script directly from the terminal that will allow the user to run the script without having to download it first.
- Prompt the user for their machine name and store it in the MACHINE environment variable, which will be used in the .profile file to set the MACHINE variable for future use.
