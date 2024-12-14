#!/bin/bash

source "$HOME/.dotfiles/.env"

role=$( printf "$POSSIBLE_AWS_ROLES" | fzf --height=10% --border --border-label "$CURRENT_AWS_ACCOUNT_NAME - $CURRENT_AWS_ACCOUNT_ID")

awslogin file -a $CURRENT_AWS_ACCOUNT_ID -r $role -f

