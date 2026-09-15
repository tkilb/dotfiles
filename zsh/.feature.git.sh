##################################################
# Settings
##################################################
git config --global pager.branch false
git config --global pager.diff 'sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less'
export GIT_EDITOR="nvim"

##################################################
# Aliases
##################################################
alias gg='lazygit'
alias main="(git checkout main || git checkout master) && git fetch && git pull"
alias ohgit='git add . && c "Working through gitlab." --no-verify && git push --no-verify'
alias ss='git fetch && git status'

git-bak() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  datestamp=$(date +"%Y%m%d-%H%M%S" | tr -d ':' )
  bakBranch=bak_$1
  hasChanges=$(git status | grep ^Changes)
  [ -n "$1" ] && bakBranch='bak_'$1 || bakBranch='bak_'$branch'_'$datestamp
  [ "$1" = "gsr" ] && bakBranch='gsr_'$branch'_'$datestamp
  [ "$1" = "bak" ] && bakBranch='bak'
  git branch -D $bakBranch \
  ; ([ -n "$hasChanges" ] && git add . && git stash || echo 'Nothing to stash') \
  && git checkout -b $bakBranch \
  && ([ -n "$hasChanges" ] && git stash apply || echo 'Nothing to stash') \
  && git add . \
  && (git commit -m 'Work in progress...' --no-verify || echo 'Nothing to commit') \
  && git checkout $branch \
  && ([ -n "$hasChanges" ] && git stash pop || echo 'Nothing in stash')
}

git-clear() {
  printf 'Are you sure you want to nuke stuff? [y/N]'
  read confirm
  if [[ $confirm = 'y' ]] ; then
    git add . \
    && git stash \
    && git reset \
    && git checkout . \
    && git clean -fd
  fi
}

git-diff-stat() {
  if [[ $1 =~ '^[0-9]+$' ]] ; then
  git diff --stat --color head~$1
  else
  git diff --stat --color $@
  fi
}

git-status() {
  if [[ $1 = '' ]] ; then; git status -s; fi
  if [[ $1 = 'u' ]] ; then; git status -s | grep '^?? ' --color | sed s/^\?\?\ //g; fi
  if [[ $1 = 'm' ]] ; then; git status -s | grep '^\ \M' --color; fi
  if [[ $1 = 's' ]] ; then; git status -s | grep '^\M\ ' --color; fi
}

git-warp() {
  if [ -n "$1" ]; then
    local sha="$1"
    printf 'Are you sure you want goto the state of this sha, it will nuke changes? [y/N]'
    read confirm
    if [[ $confirm = 'y' ]] ; then
      git reset --hard $sha
      git reset --soft HEAD@{1}
      git commit -m "Updating to the state of the project at $sha" --no-verify
    fi
  fi
}

jerk() {
  printf 'Are you sure you want to force push? [y/N]'
  read confirm
  if [[ $confirm = 'y' ]] ; then
    git add . \
    && git commit --amend --no-verify --no-edit \
    && git push -f --no-verify
  fi
}

pushu() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  git push --set-upstream origin $branch
}

pushu-nv() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  git push --set-upstream origin $branch --no-verify
}

s() {
  local filter
  case $1 in
    [m]*)
    filter="^(M| )M"
    ;;
  esac
  if [[ -n $filter ]]; then
    git-status | grep -i "$filter"
  else
    git-status
  fi
}
