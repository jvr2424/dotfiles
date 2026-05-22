#!/usr/bin/env bash

# Script to list all tmux sessions with their windows and current working directories

# Check if tmux is running
if ! tmux list-sessions &>/dev/null; then
    echo "No tmux sessions are currently running."
    exit 0
fi

# Get all sessions
sessions=$(tmux list-sessions -F '#{session_name}')

# Iterate through each session
while IFS= read -r session; do
    echo "Session: $session"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Get all windows in the session
    windows=$(tmux list-windows -t "$session" -F '#{window_index}:#{window_name}')

    while IFS= read -r window; do
        window_index=$(echo "$window" | cut -d: -f1)
        window_name=$(echo "$window" | cut -d: -f2-)

        # Get the current path of the window's active pane
        pwd=$(tmux display-message -p -t "${session}:${window_index}" -F '#{pane_current_path}')

        echo "  Window ${window_index}: ${window_name}"
        echo "    PWD: ${pwd}"
    done <<< "$windows"

    echo ""
done <<< "$sessions"
