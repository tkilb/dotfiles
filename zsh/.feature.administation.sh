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
  # Note: suspending/backgrounding jobs invoked from *any* shell function
  # (this one included) hits a known zsh limitation where `jobs` shows
  # blank command text (see .feature.jobs.sh for the fix/explanation).
  # The trailing `return $?` on each branch just propagates the wrapped
  # command's real exit status.
  if command -v nvim &>/dev/null; then
    nvim "$@"
    return $?
  elif command -v vim &>/dev/null; then
    command vim "$@"
    return $?
  else
    vi "$@"
    return $?
  fi
}

##################################################
# Arch Specific
##################################################
if [[ "$MACHINE" =~ ^(linux-book|linux-box)$ ]]; then
  alias system-update="yay -Syyuu"

  # NAS Backups
  alias mount-onsite-backup="sudo mkdir -p /mnt/onsite-backup && sudo mount /dev/disk/by-label/onsite-backup /mnt/onsite-backup"
  alias unmount-onsite-backup="sudo umount /mnt/onsite-backup ; sudo rmdir /mnt/onsite-backup"
  alias bak-d2="rsync --progress --partial --archive --delete /mnt/nas/d2 /mnt/onsite-backup/d2"
  alias bak-d3="rsync --progress --partial --archive --delete /mnt/nas/d3 /mnt/onsite-backup/d3"
fi

##################################################
# Debian Specific
##################################################
if [[ "$MACHINE" = "pi-server" ]]; then
  alias system-update="sudo apt update && sudo apt upgrade && (command -v brew &>/dev/null && brew update && brew upgrade || true)"
fi

