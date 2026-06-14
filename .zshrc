# Set AWS_PROFILE and kubeconfig
function set_eks_profile() {
  export myprofile="$1"
  export myenv="$2"
  export AWS_PROFILE="$3"
  eks_cluster="$4"
  echo "myenv=$myenv"
  if ! aws sts get-caller-identity 1>/dev/null 2>/dev/null; then
    aws sso login
  fi
  if [[ -n "$eks_cluster" ]]; then
    aws eks update-kubeconfig --name "$eks_cluster"
  fi
}

# Open files with vscode
function codes() {
  for file in $(find . -name "*${1}"); do
    echo "$file"
    code "$file"
  done
}

# Login to ECR
function ecr-login() {
  if ! docker info 1>/dev/null 2>/dev/null; then
    echo "Docker Desktop is not running" 1>&2
    return 1
  fi
  ecr_endpoint="$(aws sts get-caller-identity --query Account --output text).dkr.ecr.ap-northeast-1.amazonaws.com"
  read "ANSWER?Log in to $ecr_endpoint ? (y/n) "
  if [ "$ANSWER" != "y" ]; then
    echo "Canceled" 1>&2
    return 1
  fi
  aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin "$ecr_endpoint"
}

# homebrew
# https://docs.brew.sh/Shell-Completion
eval "$(/opt/homebrew/bin/brew shellenv)"
autoload -Uz compinit
compinit

# zsh-autosuggestions
. /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
export FZF_DEFAULT_OPTS='--reverse'
source <(fzf --zsh)

# starship
export STARSHIP_CONFIG="$HOME/.starship.toml"
eval "$(starship init zsh)"

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# fnm
eval "$(fnm env --use-on-cd)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# rbenv
eval "$(rbenv init - zsh)"

# k8s kubectl
source <(kubectl completion zsh)

# # k8s krew https://krew.sigs.k8s.io/docs/user-guide/setup/install/
export PATH="${PATH}:${HOME}/.krew/bin"

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000 # memory
export SAVEHIST=50000 # file
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# less
export LESSHISTFILE=- # don't save history

# Aliases
alias bb='brew bundle --global' # e.g. bb list --all
alias -g g='git'
alias -g k='kubectl'
alias -g sed='gsed'
alias k9sr='k9s --readonly'
alias ll='ls -alhF'
alias diff='colordiff -u'
alias difff='colordiff -y --suppress-common-lines'
alias fig='docker-compose' 
alias c-aws='code ~/.aws/'
alias c-dot='code ~/Documents/tippy3/dotfiles/'
alias c-ssh='code ~/.ssh/'
alias s-zsh='source ~/.zshrc'

# bindkey
bindkey '^[[1;2A' kill-word # Shift + Up
bindkey '^[[1;2B' kill-line # Shift + Down
bindkey '^[[1;2C' forward-word # Shift + Right
bindkey '^[[1;2D' backward-word # Shift + Left

# include private settings
. ~/Documents/tippy3/dotfiles/private/.zshrc
