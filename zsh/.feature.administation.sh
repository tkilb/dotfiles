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

alias vi="nvim"
alias vim="nvim"


##################################################
# Personal Linux Machines
##################################################
if [[ "$MACHINE" =~ ^(linux-book|linux-box)$ ]]; then
  alias bak-d2="rsync --progress --partial --archive --delete /run/user/1000/gvfs/smb-share:server=192.168.0.123,share=d2/ /run/media/tylerkilburn/onsite-backup/d2"
  alias bak-d3="rsync --progress --partial --archive --delete /run/user/1000/gvfs/smb-share:server=192.168.0.123,share=d3/ /run/media/tylerkilburn/onsite-backup/d3"
  alias system-update="yay -Syyuu"
fi

