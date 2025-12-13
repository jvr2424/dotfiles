#!/usr/bin/env bash

selected_session=$(tmux ls | fzf)
session_name=$(echo "$selected_session" | sed 's/:.*//')

tmux switch-client -t "$session_name"

