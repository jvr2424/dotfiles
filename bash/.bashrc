# The various escape codes that we can use to color our prompt.
RED="\[\033[0;31m\]"
YELLOW="\[\033[1;33m\]"
ORANGE="\[\033[38;5;222m\]"
ORANGE_DARK="\[\033[38;5;214m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[1;34m\]"
PURPLE="\[\033[0;35m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
GRAY="\[\033[90m\]"
COLOR_NONE="\[\e[0m\]"

function set_virtualenv() {
  # Get Python virtual env name if activated
  if [[ "$VIRTUAL_ENV" != "" ]]; then
    local venv_basename=$(basename "$VIRTUAL_ENV")
    VENV="${BLUE}[${venv_basename}]${COLOR_NONE} "
  else
    VENV=""
  fi
}

function get_pr_number() {
  # Get PR number for current branch if it exists
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "$branch" ]]; then
      local pr_number=$(gh pr list --head "$branch" --json number --jq '.[0].number' 2>/dev/null)
      if [[ -n "$pr_number" ]]; then
        echo " ${GRAY}PR #${pr_number}${COLOR_NONE}"
        return
      fi
    fi
  fi
  echo ""
}

# shows a * for unstaged and + for staged files
GIT_PS1_SHOWDIRTYSTATE=1

# shows a $ if aything is stashed
GIT_PS1_SHOWSTASHSTATE=

# shows a % if there are untracked files
GIT_PS1_SHOWUNTRACKEDFILES=

# shows colors baed on output of git status -sb
GIT_PS1_SHOWCOLORHINTS=

PROMPT_SYMBOL="${WHITE}>${COLOR_NONE}"

function set_bash_prompt() {

  # Set the VENV variable.
  set_virtualenv

  # Get PR number if it exists
  local pr_info=$(get_pr_number)

  export PS1="${VENV}${GREEN}\u\[${YELLOW}\]\w\[${BLUE}\]$(__git_ps1)${pr_info}${COLOR_NONE}\n${PROMPT_SYMBOL} "
}

PROMPT_COMMAND=set_bash_prompt

HISTSIZE=
HISTFILESIZE=

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:$PATH"
if [[ -r /etc/ssl/certs/ca-bundle-full.crt ]]; then
  export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle-full.crt
  export AWS_CA_BUNDLE=/etc/ssl/certs/ca-bundle-full.crt
  export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-bundle-full.crt
else
  unset SSL_CERT_FILE AWS_CA_BUNDLE REQUESTS_CA_BUNDLE
fi
export BASH_SILENCE_DEPRECATION_WARNING=1
export GIT_EDITOR=nvim
export VISUAL=nvim
export EDITOR="$VISUAL"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# VI Mode in bash (use v to enter text in nvim [visual and editor vars above])
set -o vi

# dotfiles-managed environment (PROJECTS_DIR, OBSIDIAN_DIR, etc.)
[ -f "$HOME/.dotfiles/.env" ] && . "$HOME/.dotfiles/.env"

#tmux
source "$HOME/.scripts/tmux_on_start.sh"

# custom script for opeing git remote and pr
source "$HOME/.scripts/git_open_remote.sh"
source "$HOME/.scripts/service_catalog_repo.sh"

# claude code
[ -f "$HOME/.claude.env" ] && source "$HOME/.claude.env"
alias gcmd="source ~/.scripts/claude_bash_cmd.sh"

alias ocode="fd . \"$PROJECTS_DIR\" --type d | fzf | xargs -I {} code {}"
alias cdd='cd $(fd . "$PROJECTS_DIR" --type d | fzf)'
alias cdc='cdd && code .'
alias cdt='cd $(git rev-parse --show-toplevel)'
alias lsm="ls ~/Downloads/*.json -alth | head -n 3"
alias cpm="source ~/.scripts/copy_model.sh"
alias skom="source ~/.scripts/open_model.sh"
alias cpd="source ~/.scripts/copy_latest_downloads_realpath.sh"
alias cpp="realpath . | tr -d '\n' | pbcopy"
alias mkvenv="source ~/.scripts/create_venv.sh"
alias acvenv="source ~/.scripts/activate_venv.sh"
alias dotgit="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias cpsn="source ~/.scripts/copy_schema_name.sh"
alias awslogin="/opt/homebrew/Cellar/awslogin/2.7.0/bin/awslogin"
alias awslf="source ~/.scripts/awslogin_helper.sh"
alias gitor="get_git_remote_url | xargs open"
alias gitopr="get_git_pr_search_url | xargs open"
alias gitobr="get_git_branch_url | xargs open"
alias gitl="source ~/.scripts/git_log.sh"

alias scpipe="get_service_catalog_pipeline_url | xargs open"
alias scc="get_service_catalog_container_url | xargs open"

alias ruff_df="source ~/.scripts/ruff_disable_formatting.sh"

alias ls="ls  --color"
alias ll="ls -lh --color"
alias lt="ls -lht --color"
alias cdob='cd "$OBSIDIAN_DIR"'

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env" || export PATH="$HOME/.cargo/bin:$PATH"

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

export PATH=$HOME/.rill:$PATH # Added by Rill install

# Added by git-ai installer on Wed Jun 10 13:55:02 EDT 2026
export PATH="$HOME/.git-ai/bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
