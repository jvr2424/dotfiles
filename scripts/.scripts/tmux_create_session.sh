#!/usr/bin/env bash

ENV_FILE="$HOME/.dotfiles/.env"
[ -r "$ENV_FILE" ] && source "$ENV_FILE"

if [ ! -d "${PROJECTS_DIR:-}" ]; then
    echo "PROJECTS_DIR is unset or is not a directory: ${PROJECTS_DIR:-<unset>}" >&2
    return 1
fi


selected_path=$(fd . "$PROJECTS_DIR" --type d | fzf)
[ -n "$selected_path" ] || return 0

if [ "${1:-}" = "--window" ]; then
    cd "$selected_path" || return 1
    exec "${SHELL:-/bin/bash}" -l
fi
session_name=$(basename "$selected_path")

tmux new -s  "$session_name" -d  #"$SHELL -c '$selected_path && exec $SHELL -l'"
tmux send-keys -t "$session_name:1" "cd \"$selected_path\" && clear" C-m
tmux switch-client -t "$session_name"

