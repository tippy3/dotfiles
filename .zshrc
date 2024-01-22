autoload -Uz compinit && compinit

# git status
function prompt_git_branch {
  local branch_name st branch_status
  if [ ! -e  ".git" ]; then
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    echo "%F{red}!(no branch)"
    return
  else
    branch_status="%F{blue}"
  fi
  echo "${branch_status}[$branch_name]%f"
}

# AWS profile
function prompt_eks_profile {
  echo "%F{green}[$myprofile]%f"
}
function set_eks_profile {
  export myprofile="$1"
  export myenv="$2"
  echo "myenv=$myenv"
  export AWS_PROFILE="$3"
  eks_cluster="$4"
  if [[ -n "$eks_cluster" ]]; then
    aws eks update-kubeconfig --name "$eks_cluster" || ( aws sso login && aws eks update-kubeconfig --name "$eks_cluster" )
  fi
}

# main prompt
setopt prompt_subst
PROMPT='
%(?.%F{green}.%F{red})[%* %~]%f `prompt_git_branch` `prompt_eks_profile`
%F{green}$%f '

# export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# hisotory
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=500 # memory
export SAVEHIST=5000 # file
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extended_history
alias his='history -i' # with time
alias hist='history -i 1 | grep' # search

# zsh-autosuggestions
. /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# k8s kubectl
source <(kubectl completion zsh)

# k8s krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# k8s istioctl
export PATH="$PATH:$HOME/.istioctl/bin"

# mysql-client
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/mysql-client/lib"
export CPPFLAGS="-I/usr/local/opt/mysql-client/include"

# gh
eval "$(gh completion -s zsh)"

alias bb='brew bundle --global' # e.g. bb list --all
alias g='git'
alias k='kubectl'
alias k9sr='k9s --readonly'
alias ll='ls -alhF'
alias diff='colordiff'
alias difff='colordiff -y --suppress-common-lines'
alias fig='docker-compose'
alias echoaws='echo $AWS_PROFILE && aws sts get-caller-identity'
alias c-aws='code ~/.aws/'
alias c-ssh='code ~/.ssh/'
alias c-git='code ~/.gitconfig'
alias c-zsh='code ~/.zshrc'
alias s-zsh='source ~/.zshrc'

# include private settings
. ~/Documents/tippy3/dotfiles/private/.zshrc
