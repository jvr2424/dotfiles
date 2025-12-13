query_param=$1

# update repo
git -C "$HOME/duckdb-web" pull

# pass param
SELECTED_FILE=$(cd "$HOME/duckdb-web/docs/stable" && realpath $(cd "$HOME/duckdb-web/docs/stable" && echo "$(rg $query_param -l -t md)$(fd $query_param -e md)" | sort | uniq | fzf ))
echo "$SELECTED_FILE" 




