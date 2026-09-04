##################################################
# Linux Shared
##################################################
rsa-keygen() {
  if [[ $1 = '' ]]; then
    echo "Missing argument"
    exit(1)
  else
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/$1 -N "" && cat ~/.ssh/$1.pub
    echo ""
    echo "Created keys:"
    # echo "~/.ssh/$1"
    echo "~/.ssh/$1.pub"
    echo ""
  fi
}

vim() {
  if command -v nvim &>/dev/null; then
    nvim "$@"
  elif command -v vim &>/dev/null; then
    command vim "$@"
  else
    vi "$@"
  fi
}

##################################################
# Personal Linux Machines
##################################################
if [[ "$MACHINE" =~ ^(linux-book|linux-box)$ ]]; then
  alias system-update="yay -Syyuu"

  # NAS Backups
  alias mount-onsite-backup="sudo mkdir -p /mnt/onsite-backup && sudo mount /dev/disk/by-label/onsite-backup /mnt/onsite-backup"
  alias unmount-onsite-backup="sudo umount /mnt/onsite-backup"
  alias bak-d2="rsync --progress --partial --archive --delete /mnt/nas/d2 /mnt/onsite-backup/d2"
  alias bak-d3="rsync --progress --partial --archive --delete /mnt/nas/d3 /mnt/onsite-backup/d3"
fi

