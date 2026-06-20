# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
autoload -Uz compinit
compinit

# zsh-autosuggestions
. /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
export FZF_DEFAULT_OPTS="--reverse"
export FZF_CTRL_R_OPTS="--bind 'ctrl-e:become(printf %s {q})'"
source <(fzf --zsh)

# fzf-tab
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh

# carapace
# https://carapace-sh.github.io/carapace-bin/setup.html
export CARAPACE_BRIDGES='zsh,bash'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

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
(( $+functions[kubectl] )) && unfunction kubectl
source <(kubectl completion zsh)

# k8s krew
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
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
alias c-kube='code ~/.kube/'
alias c-dot='code ~/Documents/tippy3/dotfiles/'
alias c-ssh='code ~/.ssh/'
alias s-zsh='source ~/.zshrc'

# bindkey
bindkey '^[[1;2A' kill-word # Shift + Up
bindkey '^[[1;2B' kill-line # Shift + Down
bindkey '^[[1;2C' forward-word # Shift + Right
bindkey '^[[1;2D' backward-word # Shift + Left

# Set MY_CONTEXT
function set_my_context() {
  export MY_CONTEXT="$1"
  export AWS_PROFILE="$2"
  eks_cluster="$3"

  aws_account_id="$(aws sts get-caller-identity --query Account --output text)"
  # Login to SSO
  if [[ -z "$aws_account_id" ]]; then
    aws sso login
    aws_account_id="$(aws sts get-caller-identity --query Account --output text)"
  fi
  # Update kubeconfig
  if [[ -n "$eks_cluster" ]]; then
    aws eks update-kubeconfig --name "$eks_cluster" --alias "$MY_CONTEXT" --user-alias "$MY_CONTEXT"
    kubectl --context "$MY_CONTEXT" config unset current-context
  fi
  # Login to ECR
  if docker info 1>/dev/null 2>/dev/null; then
    ecr_endpoint="$aws_account_id.dkr.ecr.ap-northeast-1.amazonaws.com"
    aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin "$ecr_endpoint"
  else
    echo "docker login is skipped"
  fi
  message="MY_CONTEXT: $MY_CONTEXT, AWS: $AWS_PROFILE ($aws_account_id), EKS: $eks_cluster"
  printf '\033[1;32m%s\033[0m\n' "$message"
}

# Override kubectl
function kubectl() {
  if [ -z "${MY_CONTEXT:-}" ]; then
    echo "error: MY_CONTEXT is not set" >&2
    return 1
  fi
  command kubectl --context "$MY_CONTEXT" "$@"
}

# Override k9s
function k9s() {
  if [ -z "${MY_CONTEXT:-}" ]; then
    echo "error: MY_CONTEXT is not set" >&2
    return 1
  fi
  command k9s --context "$MY_CONTEXT" "$@"
}

# Open files with vscode
function codes() {
  for file in $(find . -name "*${1}"); do
    echo "$file"
    code "$file"
  done
}

# git pull && git branch -d
function gpl() {
  local current_branch default_branch merged_branches

  current_branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)"
  default_branch="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')"
  : "${default_branch:=main}"

  if [[ "$current_branch" != "$default_branch" ]]; then
    echo "error: current branch ($current_branch) is not the default branch ($default_branch)" >&2
    return 1
  fi

  git pull --ff-only origin "$default_branch"

  merged_branches="$(git branch --merged | sed 's/^[* ]*//' | grep -vE "^(${default_branch}|main|master|gh-pages)$")"

  if [[ -n "$merged_branches" ]]; then
    echo "Deleting merged branches"
    echo "$merged_branches" | xargs git branch -d
  fi
}

# include private settings
. ~/Documents/tippy3/dotfiles/private/.zshrc
