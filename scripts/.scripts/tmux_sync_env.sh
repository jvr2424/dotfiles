#!/usr/bin/env bash
# Push dotfiles .env vars into tmux's own server-global environment.
#
# tmux expands $VAR in bind-key commands using a snapshot of the environment
# taken when the server started, not the environment of whatever shell later
# runs `source-file`. Without this, editing .env and reloading tmux.conf
# (prefix + r) has no effect until the whole tmux server is restarted.
ENV_FILE="$HOME/.dotfiles/.env"
[ -f "$ENV_FILE" ] || exit 0

set -a
source "$ENV_FILE"
set +a

for var in PROJECTS_DIR OBSIDIAN_DIR; do
    value="${!var}"
    [ -n "$value" ] && tmux set-environment -g "$var" "$value"
done
