
#!/usr/bin/env bash

selected_path=$(fd . ~/projects --type d | fzf)
session_name=$(basename "$selected_path")

tmux new -s  "$session_name" -d  #"$SHELL -c '$selected_path && exec $SHELL -l'"
tmux send-keys -t "$session_name:1" "cd \"$selected_path\" && clear" C-m
tmux switch-client -t "$session_name"

