##################################################
# Settings
##################################################
git config --global pager.branch false
git config --global pager.diff 'sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less'
export GIT_EDITOR="nvim"

##################################################
# Aliases
##################################################
alias append="git log -1 --pretty=%B | xargs -0 git commit -m"
alias appendpush="git add . && append && git push"
alias ca="git add . && c"
alias can="git add . && cn"
alias co="git checkout"
alias ct='git add . && git commit --no-verify -m "Work in progress..."'
alias d='git-diff'
alias ohgit='git add . && c "Working through gitlab." --no-verify && git push --no-verify'
alias ds='git-diff-stat'
alias git-amend="git commit --amend --no-verify --no-edit"
alias git-amend-add="git add . && git commit --amend  --no-verify --no-edit"
alias gbm="git branch --merged | egrep -v \"(^\*|master|dev)\""
alias glock="rm .git/index.lock"
alias git-bak-rm='git branch -a | grep "bak_\|gsr_" | xargs git branch -D'
alias gitit='tmpl-git && git init && git add . && git commit -m "Initial commit" && code ./.gitignore'
# alias git-personal="cp -f ~/.ssh/config-personal ~/.ssh/config"
alias git-prune="git remote prune origin && git-purge"
alias git-purge="git branch --merged main | grep -v '^[ *]*main$' | xargs git branch -d"
# alias git-purge-main="git branch --merged main | grep -v '^[ *]*main$' | xargs git branch -d"
alias git-sha='git rev-parse HEAD | cut -c1-11 && git rev-parse HEAD | pbcopy'
alias git-sha-full='git rev-parse HEAD && git rev-parse HEAD | pbcopy'
alias git-snap="git stash && git stash apply stash@{0}"
alias git-stash-loose="git stash -k -u -m \"stash of loose items\""
alias git-stash-staged="git stash --keep-index && git stash push -m \"stash of staged items\""
alias git-stack="git merge --no-commit --squash"
# alias git-work="cp -f ~/.ssh/config-work ~/.ssh/config"
alias grc='git rebase --continue'
# alias gsa='git stash apply'
alias gsl='git stash list'
alias ghr='git-bak ghr && git reset head^ --hard'
alias gsr='git-bak gsr && git reset head^ --soft'
alias l='git log'
alias lg="git log --graph --pretty=format:'commit: %C(bold red)%h%Creset %C(red)<%H>%Creset %C(bold magenta)%d %Creset%ndate: %C(bold yellow)%cd %Creset%C(yellow)%cr%Creset%nauthor: %C(bold blue)%an%Creset %C(blue)<%ae>%Creset%n%C(cyan)%s%n%Creset'"
alias lg__idk="git log --graph --full-history --all --color \--pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\""
alias main="(git checkout main || git checkout master) && git fetch && git pull"
# alias master="git checkout master && git fetch && git remote prune origin && git-purge && git pull"
# alias main="git checkout main && git fetch && git remote prune origin && git-purge-main && git pull"
alias mmerge='git fetch && git merge origin/main --no-ff -m "Merging in main to branch"'
alias pushf="git push -f --no-verify"
alias pushn="git push --no-verify"
alias pusht="git push --no-verify && npm run test"
alias push-pr="pushu && pr"
alias push-pr-nv="pushu-nv && pr"
alias rl="git reflog"
alias rsa-rotate='ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_work -N "" && cat ~/.ssh/id_rsa_work.pub'
alias ss='git fetch && git status'
# alias stashstaged='git stash --keep-index && git stash && git stash apply stash@{1} && git stash drop stash@{1}'


b() {
  if [[ $1 == "l" ]]; then
    git branch | grep -i "$2"
  elif [[ $1 == "o" ]]; then
    git fetch; git branch --all | grep remotes\/origin\/ | sed "s/remotes\/origin\///" | grep -i "$2" | tail -r
  else
    git branch --all | grep -i "$1" | tail -r
  fi
}

cx() {
  jirabranch=$(git rev-parse --abbrev-ref HEAD | sed 's/.*\/\([0-9]*\)-.*/\1/g')
  [ -n "$jirabranch" ] && msg=$(echo $jirabranch - $1) || msg=$1
  shift
  echo $msg
  # git commit -m "$msg" $@
}

c() {
  jirabranch=$(git rev-parse --abbrev-ref HEAD | sed -n 's/.*\(^[A-Z]*-[0-9]*\)_.*/\1/p')
  [ -n "$jirabranch" ] && msg=$(echo \[$jirabranch\] $1) || msg=$1
  shift
  git commit -m "$msg" $@
}

clone() {
  local dir=$(pwd)
  local gitFile="${1/*\//}"
  local dirLocal="${gitFile/.git/}"

  cd ~/Git
  git clone $1

  cd $dir
  code ~/Git/$dirLocal/
}

clonep() {
  local dir=$(pwd)
  local gitFile="${1/*\//}"
  local dirLocal="${gitFile/.git/}"

  cd ~/Git
  git clone "${1/com:tkil/com-tkil:tkil}"

  cd $dir
  code ~/Git/$dirLocal/
}

cn() {
  msg=$1
  shift
  c "$msg" --no-verify $@
}

git-delete-all-local() {
    printf 'Are you sure you delete all your local branches? [y/N]'
    read confirm
    if [[ $confirm = 'y' ]] ; then
      printf 'Really??? [y/N]'
      read confirm2
      if [[ $confirm2 = 'y' ]] ; then
        git for-each-ref --format '%(refname:short)' refs/heads | grep -v "master\|main" | xargs git branch -D
      fi
    fi
}

gbdd() {
  git branch | grep -i $1
  printf 'Are you sure you want to perma delete these? [y/N]'
  read confirm
  if [[ $confirm = 'y' ]] ; then
    git branch -D $(git branch | grep $1)
  fi
}

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

git-diff() {
  if [[ $1 =~ '^[0-9]+$' ]] ; then
  git diff --color head~$1 | less -p diff\ --git
  else
  git diff --color $@ | less -p diff\ --git
  fi
}

git-diff-stat() {
  if [[ $1 =~ '^[0-9]+$' ]] ; then
  git diff --stat --color head~$1
  else
  git diff --stat --color $@
  fi
}

git-expire() {
  local gitExpireFile=$(pwd)/.gitexpire
  local newExp=$(date -v +14d -u +"%Y-%m-%dT%H:%M:%SZ")
  local color='\033[0;37m\033[0;40m'

  # Bump expiration 14 days from now
  echo "$newExp" > "$gitExpireFile" 
  echo "$color  .gitexpire updated to $newExp  "
}

git-expired() {
  local gitExpireFile=$(pwd)/.gitexpire
  local newExp=$(date -v -30d -u +"%Y-%m-%dT%H:%M:%SZ")
  local color='\033[0;37m\033[0;41m'

  echo "$newExp" > "$gitExpireFile" 
  echo "$color  .gitexpire SET TO EXPIRE"
}

git-status() {
  if [[ $1 = '' ]] ; then; git status -s; fi
  if [[ $1 = 'u' ]] ; then; git status -s | grep '^?? ' --color | sed s/^\?\?\ //g; fi
  if [[ $1 = 'm' ]] ; then; git status -s | grep '^\ \M' --color; fi
  if [[ $1 = 's' ]] ; then; git status -s | grep '^\M\ ' --color; fi
}

git-staging-replace() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  git branch -D staging
  git checkout -b staging
  git push --set-upstream origin staging --force --no-verify
  git checkout $branch
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

gsa() {
  if [[ -n $1 ]]; then
    git stash apply stash@{$1}
  else 
    git stash apply
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
