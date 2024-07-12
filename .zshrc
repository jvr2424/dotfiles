# #!/bin/zsh
# # The various escape codes that we can use to color our prompt.
# RED="%F{red}"
# YELLOW="%F{yellow}"
# ORANGE="%F{222}"
# ORANGE_DARK="%F{214}"
# GREEN="%F{green}"
# BLUE="%F{blue}"
# PURPLE="%F{magenta}"
# LIGHT_RED="%F{red}"
# LIGHT_GREEN="%F{green}"
# WHITE="%F{white}"
# LIGHT_GRAY="%F{white}"
# COLOR_NONE="%f"

# function set_virtualenv() {
#     # Get python virtual env if activated
#     if [[ "$VIRTUAL_ENV" != "" ]]; then
#         VENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
#     else
#         VENV=""
#     fi
# }

# Virtual environment prompt information
virtualenv_prompt_info() {
  local venv_info=""

  if [[ -n $VIRTUAL_ENV ]]; then
    local venv_name=$(basename "$VIRTUAL_ENV")
    venv_info+="%F{blue}($venv_name) "  # Virtual environment name
  fi

  echo $venv_info
}

# function set_git_branch() {
#     # Get git branch name, number of untracked, modified, and deleted files
#     if [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
#         GIT_BRANCH="$(command git branch | grep \* | cut -d ' ' -f2)"
#         GIT_CHANGED=" ${ORANGE}M$(command git status --porcelain | grep "^ M" -wc)"
#         GIT_UNTRACKED=" ${GREEN}U$(command git status --porcelain | grep "^??" -wc)"
#         GIT_DELETED=" ${RED}D$(command git status --porcelain | grep "^ D" -wc)"

#         if [[ "$GIT_CHANGED" == " ${ORANGE}M0" ]]; then
#             GIT_CHANGED=""
#         fi
#         if [[ "$GIT_UNTRACKED" == " ${GREEN}U0" ]]; then
#             GIT_UNTRACKED=""
#         fi
#         if [[ "$GIT_DELETED" == " ${RED}D0" ]]; then
#             GIT_DELETED=""
#         fi

#         GIT_STATUS=" %{${ORANGE_DARK}%}(${GIT_BRANCH}${GIT_CHANGED}${GIT_UNTRACKED}${GIT_DELETED}%{${ORANGE_DARK}%})${COLOR_NONE}"
#     else
#         GIT_STATUS=""
#     fi
# }

# PROMPT_SYMBOL="${WHITE}>${COLOR_NONE}"

# function set_zsh_prompt() {
#     # Set VENV variable
#     set_virtualenv

#     # Set GIT_STATUS variable
#     set_git_branch

#     # Set the Zsh prompt variable
#     PS1="${VENV}${GREEN}[%n@%M]${BLUE}%~${GIT_STATUS}
# ${PROMPT_SYMBOL}"
# }

# autoload -U add-zsh-hook
# add-zsh-hook precmd set_zsh_prompt
setopt prompt_subst

# Based on bira theme
function __git_prompt_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

function git_prompt_info() {
  # If we are on a folder not tracked by git, get out.
  # Otherwise, check for hide-info at global and local repository level
  if ! __git_prompt_git rev-parse --git-dir &> /dev/null \
     || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]; then
    return 0
  fi

  local ref
  ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
  || return 0

  # Use global ZSH_THEME_GIT_SHOW_UPSTREAM=1 for including upstream remote info
  local upstream
  if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
    upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
    && upstream=" -> ${upstream}"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${upstream:gs/%/%%}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}




set_zsh_prompt() {

    local PR_USER PR_USER_OP PR_PROMPT PR_HOST

    # Check the UID
    if [[ $UID -ne 0 ]]; then # normal user
    PR_USER='%F{green}%n%f'
    PR_USER_OP='%F{green}%#%f'
    PR_PROMPT='%f➤ %f'
    else # root
    PR_USER='%F{red}%n%f'
    PR_USER_OP='%F{red}%#%f'
    PR_PROMPT='%F{red}➤ %f'
    fi

    # Check if we are on SSH or not
    if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
    PR_HOST='%F{red}%M%f' # SSH
    else
    PR_HOST='%F{green}%M%f' # no SSH
    fi


    local return_code="%(?..%F{red}%? ↵%f)"

    local user_host="${PR_USER}%F{cyan}@${PR_HOST}"
    local current_dir="%B%F{blue}%~%f%b"
    local git_branch='$(git_prompt_info)'
    local python_venv='$(virtualenv_prompt_info)'

    PROMPT="╭─${python_venv}${user_host} ${current_dir} ${git_branch}
╰─$PR_PROMPT "
    RPROMPT="${return_code}"

    ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
    ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"

}
autoload -U add-zsh-hook
add-zsh-hook precmd set_zsh_prompt
export NVM_DIR="$HOME/.reflex/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/joeracaniello/.reflex/.bun/_bun" ] && source "/Users/joeracaniello/.reflex/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.reflex/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


#aliases
alias dotgit="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"