#!/bin/bash

# Check if prompt argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No prompt provided"
    echo "Usage: $0 \"your prompt here\""
    exit 1
fi

# Get the prompt from the first argument
# PROMPT="You are an expert using various bash and mac command line tools and commands. The user will ask for correct usage of a command. Please answer their request
# $1"

PROMPT="$1"

# default to claude
if [[ -z "$2" ]]; then
    # Run claude with the prompt and extract the command, store in variable
    COMMAND=$(claude -p "$PROMPT" \
      --output-format json \
      --json-schema '{"type":"object","properties":{"command":{"type":"string"}},"required":["command"]}' \
      | jq -r .structured_output.command)
else
    # use ollama model

    PAYLOAD=$(jq -n --arg model "$2" --arg content "$PROMPT" \
      '{model: $model, messages: [{role: "user", content: $content}], stream: false, think: false, format: {type: "object", properties: {command: {type: "string"}}, required: ["command"]}}')

    COMMAND=$(curl -s http://localhost:11434/api/chat -d "$PAYLOAD" | jq -r .message.content | jq -r .command)
fi


# Echo the command
echo "$COMMAND" | pbcopy
echo "$COMMAND"
