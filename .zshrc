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

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit
compinit

# zsh-autosuggestions
. /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# k8s kubectl
source <(kubectl completion zsh)

# # k8s krew
export PATH="${PATH}:${HOME}/.krew/bin"

# # k8s istioctl
# export PATH="$PATH:$HOME/.istioctl/bin"

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

# GNU command
alias -g sed='gsed'

# shortcuts
alias bb='brew bundle --global' # e.g. bb list --all
alias -g g='git'
alias -g k='kubectl'
alias k9sr='k9s --readonly'
alias ll='ls -alhF'
alias diff='colordiff -u'
alias difff='colordiff -y --suppress-common-lines'
alias fig='docker-compose' 
alias c-aws='code ~/.aws/'
alias c-dot='code ~/Documents/tippy3/dotfiles/'
alias c-ssh='code ~/.ssh/'
alias s-zsh='source ~/.zshrc'

# include private settings
. ~/Documents/tippy3/dotfiles/private/.zshrc
