#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
ANSIBLE_DIR="$DOTFILES_DIR/ansible"

cd "$DOTFILES_DIR"

# Bootstrap Ansible itself if it isn't already on PATH.
if ! command -v ansible-playbook &>/dev/null; then
    echo "Ansible not found — installing..."
    if [[ "$(uname)" == "Darwin" ]]; then
        if ! command -v brew &>/dev/null; then
            echo "Homebrew not found — installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install ansible
    else
        sudo apt-get update
        sudo apt-get install -y ansible
    fi
fi

# All 4 machines are listed in inventory.ini, but each machine only ever
# runs the playbook against itself — --limit keeps a run on one host from
# touching another host's tasks (e.g. Mac-only tasks on an Ubuntu server).
exec ansible-playbook \
    -i "$ANSIBLE_DIR/inventory.ini" \
    "$ANSIBLE_DIR/site.yml" \
    --limit "$(hostname -s)" \
    "$@"
