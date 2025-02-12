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


  export PS1="${VENV}${GREEN}\u\[${YELLOW}\]\w\[${BLUE}\]$(__git_ps1)${COLOR_NONE}\n${PROMPT_SYMBOL} "
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
export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle-full.crt
export AWS_CA_BUNDLE=/etc/ssl/certs/ca-bundle-full.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-bundle-full.crt
export BASH_SILENCE_DEPRECATION_WARNING=1
export JAVA_HOME=$(/usr/libexec/java_home)
export GIT_EDITOR=nvim


#tmux
source "$HOME/.scripts/tmux_on_start.sh"

# custom script for opeing git remote and pr
source "$HOME/.scripts/git_open_remote.sh"

alias ocode="fd . ~/Local_Projects --type d | fzf | xargs -I {} code {}"
alias cdd='cd $(fd . ~/Local_Projects --type d | fzf)'
alias cdc='cdd && code .'
alias lsm="ls ~/Downloads/*.json -alth | head -n 3"
alias cpm="source ~/.scripts/copy_model.sh"
alias cpd="source ~/.scripts/copy_latest_downloads_realpath.sh"
alias mkvenv="source ~/.scripts/create_venv.sh"
alias dotgit="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias cpsn="source ~/.scripts/copy_schema_name.sh"
alias awslogin="/opt/homebrew/Cellar/awslogin/2.5.0/bin/awslogin"
alias awslf="source ~/.scripts/awslogin_helper.sh"
alias gitor="get_git_remote_url | xargs open"
alias gitopr="get_git_pr_search_url | xargs open"
alias gitobr="get_git_branch_url | xargs open"
alias gitl="source ~/.scripts/git_log.sh"
alias attic_export="python /Users/jracaniell/Local_Projects/_side_projects/attic_export_cli/run_attic_export.py"

alias ls="ls  --color=auto"
alias ll="ls -lh --color=auto"
alias lt="ls -lht --color=auto"

. "$HOME/.cargo/env"
