#!/usr/bin/env bash

session_name="default"

if tmux has-session -t $session_name 2>/dev/null; then
    if [ -z "$TMUX" ]; then
        echo "Session $session_name already exists, attching to it"
        tmux attach-session -t "$session_name"
    fi

else
    # Create a new tmux session in the background
    tmux new-session -d -s "$session_name"

    # First window: Home directory
    tmux send-keys -t "$session_name:1" "cd $HOME && clear" C-m

    PATH_FILE="$HOME/.scripts/tmux_start_paths.txt"

    if [ ! -f "$PATH_FILE" ]; then
        echo "File not found: $PATH_FILE"
        exit 1
    fi

    WINDOW_NUM=2
    # Read the file line by line
    while IFS= read -r tmux_sw_path || [[ -n "$tmux_sw_path" ]]; do
        # Expand any potential home directory references
        expanded_path=$(eval echo "$tmux_sw_path")
        
        # Check if the path exists
        if [ -d "$expanded_path" ]; then
            echo "$expanded_path"
            # Create a new tmux window and change to the specified directory
            tmux new-window -t "$session_name:$WINDOW_NUM" 
            tmux send-keys -t "$session_name:$WINDOW_NUM" "cd \"$expanded_path\" && clear" C-m

            # Increment window number
            ((WINDOW_NUM++))
        else
            echo "Skipping invalid path: $expanded_path"
        fi
    done < "$PATH_FILE"



    # Select the main window (always number 2: first path in the txt file)
    tmux select-window -t "$session_name:2"

    if [ -z "$TMUX" ]; then
        tmux attach-session -t "$session_name"
    fi

fi
