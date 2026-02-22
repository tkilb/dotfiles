# Requirements

You will create a custom plugin for Ansible. This plugin will allow playbooks to use Arch Linux's 'yay' AUR helper to install packages from the Arch User Repository (AUR).

## Requirements:

- module name is yay and plugin file is yay.yaml
- The plugin should be able to handle both installing and removing packages, as well as checking if a package is already installed.
- The user always want to run Ansible playbooks using the command `ansible-playbook -K`
- Plugins will be install for the current user and not root or some proxy user
- Plugins should not fail with cryptic messages when there is an installation issue
- Use ~/.dotfiles/ansible/playbooks/ai.yaml as a test
- You may update ai.yaml in any way you need to make it work with the plugin
- Should not require tylerkilburn be added to sudo-ers for passwordless access, this is a security concern
