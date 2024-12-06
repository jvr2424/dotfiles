#!/bin/zsh

local session_name="default"

# Create a new tmux session in the background
tmux new-session -d -s "$session_name"

# First window: Home directory
tmux send-keys -t "$session_name:1" "cd ~ && clear" C-m

# Second window: First specified directory
tmux new-window -t "$session_name:2"
tmux send-keys -t "$session_name:2" "cd ~/Documents/ios_app/workout-tracker && clear" C-m

# Third window: Second specified directory
tmux new-window -t "$session_name:3"
tmux send-keys -t "$session_name:3" "cd ~/Documents/Projects/macro_tracker && clear" C-m

# Select the first window
tmux select-window -t "$session_name:2"

# Attach to the session if not already in a tmux session
if [ -z "$TMUX" ]; then
  tmux attach-session -t "$session_name"
fi
