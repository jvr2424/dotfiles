#!/bin/zsh
# The various escape codes that we can use to color our prompt.
RED="%F{red}"
YELLOW="%F{yellow}"
ORANGE="%F{222}"
ORANGE_DARK="%F{214}"
GREEN="%F{green}"
BLUE="%F{blue}"
PURPLE="%F{magenta}"
LIGHT_RED="%F{red}"
LIGHT_GREEN="%F{green}"
WHITE="%F{white}"
LIGHT_GRAY="%F{gray}"
COLOR_NONE="%f"

function set_virtualenv() {
    # Get python virtual env if activated
    if [[ -n "$VIRTUAL_ENV" ]]; then
        VENV="${BLUE}[${VIRTUAL_ENV:t}]${COLOR_NONE} "
    else
        VENV=""
    fi
}


function set_git_branch() {
    # Get git branch name, number of untracked, modified, and deleted files
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        GIT_BRANCH=$(git branch --show-current)
        GIT_CHANGED=$(git status --porcelain | wc -l | xargs)

        if [[ "$GIT_CHANGED" == "0" ]]; then
            GIT_CHANGED=""
        else
          GIT_CHANGED="${RED}*"
        fi

        GIT_STATUS=" ${BLUE}(${GIT_BRANCH}${GIT_CHANGED}${BLUE})${COLOR_NONE}"
    else
        GIT_STATUS=""
    fi
}

PROMPT_SYMBOL="${WHITE}>${COLOR_NONE}"

function set_zsh_prompt() {
    # Set VENV variable
    set_virtualenv

    # Set GIT_STATUS variable
    set_git_branch

    # Set the Zsh prompt variable
    PROMPT="${LIGHT_RED}[%T]${COLOR_NONE} ${VENV}${GREEN}%n${YELLOW}%~${GIT_STATUS}
${PROMPT_SYMBOL} "
}

precmd_functions+=(set_zsh_prompt)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory


_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

#fzf
source <(fzf --zsh)

export NVM_DIR="$HOME/.reflex/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#git completion?
autoload -Uz compinit && compinit
fpath=(~/.zsh $fpath)

# bun completions
[ -s "/Users/joeracaniello/.reflex/.bun/_bun" ] && source "/Users/joeracaniello/.reflex/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.reflex/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#tmux
source "/Users/joeracaniello/.scripts/tmux_on_start.sh"

#aliases
alias dotgit="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias ls="ls -alht --color=auto"
alias ocode="fd . ~/Documents/Projects --type d | fzf | xargs -I {} code {}"
alias cdd='cd $(fd . ~/Documents/Projects --type d |fzf)'
alias cdc='cdd && code .'
