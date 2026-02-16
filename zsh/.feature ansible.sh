ANSIBLE_CONFIG="$HOME/.ansible/ansible.cfg"

playbook() {
  local _playbook_dir="$HOME/.dotfiles/ansible/playbooks"

  if [ "$#" -eq 0 ]; then
    ls $_playbook_dir
  else
    ansible-playbook -K $_playbook_dir/$1.yaml
  fi
}
