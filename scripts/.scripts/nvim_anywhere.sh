# Fetch text from clipboard
text=$(pbpaste)

# Save to a temporary file
tempfile=$(mktemp)
echo "$text" > "$tempfile"

# Open the file in Neovim
nvim "$tempfile"

# After editing, retrieve text from the file
cat "$tempfile" | pbcopy

# Cleanup
rm "$tempfile"
