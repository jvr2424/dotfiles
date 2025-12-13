#!/usr/bin/env bash

session_name="home"

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

    first_session=$(basename $(head -n 1 "$PATH_FILE"))

    # Read the file line by line
    while IFS= read -r tmux_sw_path || [[ -n "$tmux_sw_path" ]]; do
        # Expand any potential home directory references
        expanded_path=$(eval echo "$tmux_sw_path")
        session_name=$(basename "$expanded_path")
        
        # Check if the path exists
        if [ -d "$expanded_path" ]; then
            echo "$expanded_path"
            
            if tmux has-session -t $session_name 2>/dev/null; then
                echo "session $session_name already exists"
            else
                # Create a new tmux session and change to the specified directory
                #
                tmux new -s  "$session_name" -d  
                tmux send-keys -t "$session_name:1" "cd \"$expanded_path\" && clear" C-m
            fi

        else
            echo "Skipping invalid path: $expanded_path"
        fi
    done < "$PATH_FILE"


    if [ -z "$TMUX" ]; then
        tmux attach-session -t "$first_session"
    fi

fi
