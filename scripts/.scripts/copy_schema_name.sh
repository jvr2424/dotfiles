# -o prints only matches
# -P uses pcre2 regex so we can use lookarounds and back refs
# -r replaces every match with the given text' in this case the first match group

# OLD METHOD - only return the exact schema_name
# SCHEMA_NAME=$(rg -oP -N "schema_name\s*=\s*[\"']([^\"']+)[\"']" -r '$1' src/config_environment.py)
#

# NEW METHOD - get all schema_name vars in the file, allow user to select the right one
# if theres only one copy and print

# SCHEMA_NAME=$(rg -oP -N "schema_name[_a-z0-9]*\s*=\s*[\"']([^\"']+)[\"']" -r '$1' src/config_environment.py)

SCHEMA_NAME=$(rg -oP -N "schema_name[_a-z0-9]*\s*=\s*[\"']([^\"']+)[\"']" -r '$1' -g "*config_environment.py" --no-filename)
SCHEMA_COUNT=$(echo "${SCHEMA_NAME}" | wc -l | xargs)
if [ $SCHEMA_COUNT != "1" ]; then
  SCHEMA_NAME=$(echo "${SCHEMA_NAME}" | fzf)
fi

echo "${SCHEMA_NAME}" | tr -d '\n' | pbcopy
echo "${SCHEMA_NAME}"
