#!/bin/zsh

local session_name="default"

if tmux has-session -t $session_name 2>/dev/null; then
  if [ -z "$TMUX" ]; then
    echo "Session $session_name already exists, attching to it"
    tmux attach-session -t "$session_name"
  fi

else

  # Create a new tmux session in the background
  tmux new-session -d -s "$session_name"

  # First window: Home directory
  tmux send-keys -t "$session_name:1" "cd ~ && clear" C-m

  tmux new-window -t "$session_name:2"
  tmux send-keys -t "$session_name:2" "cd ~/Documents/ios_app/workout-tracker && clear" C-m

  tmux new-window -t "$session_name:3"
  tmux send-keys -t "$session_name:3" "cd ~/Documents/Projects/macro_tracker && clear" C-m

  # Select the main window
  tmux select-window -t "$session_name:2"

  if [ -z "$TMUX" ]; then
    tmux attach-session -t "$session_name"
  fi

fi
