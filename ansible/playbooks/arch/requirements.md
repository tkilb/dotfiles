# Facts and Requirements

- User is using Arch Linux
- User has a NAS (Network Attached Storage) device that they want to set up and access
- User wants the NAS to automatically mount on boot
- NAS is using the SMB/CIFS protocol for file sharing
- User wants to access the NAS using a specific username and password
- User wants the credentials to be stored securely
- The user wants an ansible playbook to automate the setup process
- There are two mount points, smb://192.168.0.123/d2 and smb://192.168.0.123/d3 that need to be mounted
- When mounded, they should show in the path /mnt/d2 and /mnt/d3 respectively
- Since the user has gnome desktop environment, the user wants to use gnome-keyring to store the credentials securely as well. The mounted drives should be accessible in the gnome file manager (nautilus) and should not prompt for credentials when accessed.

# Implementation

Created `nas.yaml` playbook that:

1. **Installs packages**: `cifs-utils`, `gnome-keyring`, `libsecret`
2. **Creates mount points**: `/mnt/d2` and `/mnt/d3`
3. **Stores credentials securely**: `/etc/smb/credentials` (mode 0600, root only)
4. **Configures fstab**: Auto-mount entries with `x-systemd.automount` and `_netdev` for network-dependent mounts
5. **GNOME Keyring integration**: Stores credentials via `secret-tool` for Nautilus
6. **Nautilus bookmarks**: Adds SMB shares to GTK bookmarks for easy access

## Usage

```bash
cd ~/.dotfiles/ansible
NAS_USERNAME=your_user NAS_PASSWORD=your_pass ansible-playbook playbooks/arch/nas.yaml
```

**Environment variables:**
- `NAS_USERNAME` - Your NAS username (required)
- `NAS_PASSWORD` - Your NAS password (required)
