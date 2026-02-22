ANSIBLE_CONFIG="$HOME/.ansible/ansible.cfg"

playbook() {
  local _playbook_dir="$HOME/.dotfiles/ansible/playbooks/arch"
  local _opt

  while getopts "md" _opt; do
    case $_opt in
    m) _playbook_dir="$HOME/.dotfiles/ansible/playbooks/mac" ;;
    d) _playbook_dir="$HOME/.dotfiles/ansible/playbooks/debian" ;;
    esac
  done
  shift $((OPTIND - 1))

  if [ "$#" -eq 0 ]; then
    ls -1 $_playbook_dir
  else
    ansible-playbook -K $_playbook_dir/$1.yaml
  fi
}
