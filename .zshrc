# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    git
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration
alias vim='nvim'
alias vi='nvim'
alias iv='nvim'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Lazy load NVM ---
export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  unset -f nvm node npm npx yarn
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  # Optional: also check brew path if standard path fails
  if [ ! -f "$NVM_DIR/nvm.sh" ] && [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    \. "/opt/homebrew/opt/nvm/nvm.sh"
    \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  fi
}

nvm()  { lazy_load_nvm; nvm $@; }
node() { lazy_load_nvm; node $@; }
npm()  { lazy_load_nvm; npm $@; }
npx()  { lazy_load_nvm; npx $@; }
yarn() { lazy_load_nvm; yarn $@; }

# Tools
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh --cmd cd)"
source <(fzf --zsh)

export PATH="$HOME/.local/bin:$PATH"

# extra key bindings
bindkey -v
bindkey '\t\t' autosuggest-accept

. "$HOME/.local/bin/env"

# Git related
function c() {
  if [[ $# -eq 0 ]]; then
    echo "Error: Please provide a commit message."
    return 1
  fi

  git add -A
  git commit -m "$*"
}
