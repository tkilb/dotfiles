#!/usr/bin/python3

from __future__ import absolute_import, division, print_function
__metaclass__ = type

DOCUMENTATION = r'''
---
module: yay
short_description: Manage packages using yay
description:
  - Manage packages using the yay AUR helper.
  - Handles running as a non-root user while allowing sudo for pacman.
options:
  name:
    description:
      - Name of the package(s) to install or remove.
    required: true
    type: list
    elements: str
  state:
    description:
      - Desired state of the package.
    default: present
    choices: [ present, absent, latest ]
    type: str
  update_cache:
    description:
      - Whether to update the package database cache.
    default: false
    type: bool
  user:
    description:
      - The user to run yay as. Defaults to the SUDO_USER environment variable.
    required: false
    type: str
'''

EXAMPLES = r'''
- name: Install package from AUR
  yay:
    name: google-chrome
    state: present

- name: Remove package
  yay:
    name: google-chrome
    state: absent
'''

RETURN = r'''
stdout:
    description: The output of the yay command.
    type: str
stderr:
    description: The error output of the yay command.
    type: str
'''

import os
import subprocess
import tempfile
import shutil
import uuid
from ansible.module_utils.basic import AnsibleModule

def main():
    module = AnsibleModule(
        argument_spec=dict(
            name=dict(type='list', elements='str', required=True),
            state=dict(type='str', default='present', choices=['present', 'absent', 'latest']),
            update_cache=dict(type='bool', default=False),
            user=dict(type='str', required=False),
        ),
        supports_check_mode=True,
    )

    name = module.params['name']
    state = module.params['state']
    update_cache = module.params['update_cache']
    user = module.params['user']

    # Detect User
    if not user:
        user = os.environ.get('SUDO_USER')
    
    if not user:
        # Fallback: if running as non-root, use current user
        if os.geteuid() != 0:
            user = os.environ.get('USER')
        else:
             module.fail_json(msg="Could not determine user to run yay as. Please specify 'user' parameter or run via sudo.")

    # Check if we are root
    is_root = (os.geteuid() == 0)

    # If we are root, we need to ensure we can run yay as 'user'.
    # Yay will try to sudo pacman.
    # We need to configure temporary sudoers if we are root.
    
    sudoers_path = None
    if is_root:
        # Check if yay is installed
        yay_path = shutil.which('yay')
        if not yay_path:
             module.fail_json(msg="yay is not installed.")
        
        # Check if pacman is installed
        pacman_path = shutil.which('pacman')
        if not pacman_path:
             module.fail_json(msg="pacman is not installed.")

        # Create temporary sudoers file
        # Use a random suffix
        sudoers_filename = "ansible-yay-" + str(uuid.uuid4())
        sudoers_path = os.path.join('/etc/sudoers.d', sudoers_filename)
        
        try:
            # Allow user to run pacman without password
            # Also allow git if needed? No, git runs as user.
            # yay might need to run 'sudo pacman'
            with open(sudoers_path, 'w') as f:
                f.write("{user} ALL=(ALL) NOPASSWD: {pacman_path}\n".format(user=user, pacman_path=pacman_path))
            
            # Set correct permissions
            os.chmod(sudoers_path, 0o440)
            
            # Now run the logic
            execute_yay(module, name, state, update_cache, user, is_root)
            
        except Exception as e:
            module.fail_json(msg="Failed to configure sudoers or run yay: {0}".format(str(e)))
        finally:
            # Cleanup
            if sudoers_path and os.path.exists(sudoers_path):
                os.remove(sudoers_path)
    else:
        execute_yay(module, name, state, update_cache, user, is_root)


def execute_yay(module, pkgs, state, update_cache, user, is_root):
    # Query installed packages
    # yay -Q package
    
    changed = False
    messages = []
    
    # Helper to run yay as user
    def run_yay(args):
        # Base command
        cmd = ['yay', '--noconfirm'] + args
        
        if is_root:
            runuser_path = shutil.which('runuser')
            if runuser_path:
                # runuser -u user -- yay ...
                final_cmd = [runuser_path, '-u', user, '--'] + cmd
            else:
                # su - user -c "yay ..."
                # We need to quote the command for su
                cmd_str = ' '.join(cmd)
                final_cmd = ['su', '-', user, '-c', cmd_str]
        else:
            final_cmd = cmd
            
        return module.run_command(final_cmd)

    # 1. Update cache if requested
    if update_cache:
        # yay -Sy
        rc, stdout, stderr = run_yay(['-Sy'])
        if rc != 0:
            module.fail_json(msg="Failed to update cache", stdout=stdout, stderr=stderr)
        changed = True

    # 2. Check status of packages
    to_install = []
    to_remove = []
    
    for pkg in pkgs:
        # Check if installed
        rc, stdout, stderr = run_yay(['-Q', pkg])
        is_installed = (rc == 0)
        
        if state == 'present' or state == 'latest':
            if not is_installed:
                to_install.append(pkg)
            elif state == 'latest':
                # For latest, we assume if installed, we might check for updates?
                # But typically yay -S handles updates.
                pass
                
        elif state == 'absent':
            if is_installed:
                to_remove.append(pkg)

    if module.check_mode:
        module.exit_json(changed=bool(to_install or to_remove or (update_cache and changed)), msg="Check mode")

    # 3. Perform Actions
    if to_install:
        # yay -S pkg1 pkg2
        args = ['-S'] + to_install
        rc, stdout, stderr = run_yay(args)
        if rc != 0:
            module.fail_json(msg="Failed to install packages: {0}".format(to_install), stdout=stdout, stderr=stderr)
        changed = True
        messages.append("Installed {0}".format(to_install))

    if to_remove:
        # yay -R pkg1 pkg2
        args = ['-R'] + to_remove
        rc, stdout, stderr = run_yay(args)
        if rc != 0:
            module.fail_json(msg="Failed to remove packages: {0}".format(to_remove), stdout=stdout, stderr=stderr)
        changed = True
        messages.append("Removed {0}".format(to_remove))

    module.exit_json(changed=changed, msg=", ".join(messages))

if __name__ == '__main__':
    main()
