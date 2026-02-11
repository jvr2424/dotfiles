#!/bin/bash

REPO_PATH=$(git rev-parse --show-toplevel)

cat > "$REPO_PATH/ruff.toml" << 'EOF'
# This repo uses global lint settings but disables formatting

[format]
exclude = ["*"]
EOF


