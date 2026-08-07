#!/usr/bin/env bash

session=$(tmux list-sessions | \
  fzf \
    --header 'ctrl-x: kill session | ctrl-u/ctrl-d: scroll preview | ctrl-r: refresh | Enter: switch' \
    --bind 'ctrl-x:execute(s=$(echo {} | cut -d: -f1); cur=$(tmux display-message -p "#S"); if [ "$s" = "$cur" ]; then tmux switch-client -n 2>/dev/null || exit 0; fi; tmux kill-session -t "$s")+reload(tmux list-sessions 2>/dev/null)' \
    --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,ctrl-r:refresh-preview' \
    --preview-window 'follow' \
    --preview 'tmux capture-pane -ep -S -200 -t $(echo {} | cut -d: -f1); echo "---"; tmux list-windows -t $(echo {} | cut -d: -f1)')

[ -n "$session" ] && tmux switch-client -t "$(echo "$session" | cut -d: -f1)"
