#!/usr/bin/env bash

PATH_FILE="$HOME/.scripts/ssh_hosts.txt"
SELECTED_HOST=$(cat $PATH_FILE | fzf)

if [[ -n "$TMUX" ]]; then
    tmux new-window -n "$SELECTED_HOST" "ssh $SELECTED_HOST; exec $SHELL -l"
else
    ssh "$SELECTED_HOST"
fi

