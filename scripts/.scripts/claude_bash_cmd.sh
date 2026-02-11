#!/bin/bash

# Check if prompt argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No prompt provided"
    echo "Usage: $0 \"your prompt here\""
    exit 1
fi

# Get the prompt from the first argument
PROMPT="$1"

# Run claude with the prompt and extract the command, store in variable
COMMAND=$(claude -p "$PROMPT" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"command":{"type":"string"}},"required":["command"]}' \
  | jq -r .structured_output.command)

# Echo the command
echo "$COMMAND" | pbcopy
echo "$COMMAND"
