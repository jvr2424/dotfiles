function get_git_remote_url() {
    local git_remote=$(git remote -v | awk '/origin.*push/ {print $2}')

    # Check if it's already an HTTP/HTTPS URL
    if [[ "$git_remote" =~ ^https?:// ]]; then
        # Ensure it's https
        git_remote="${git_remote/http:/https:}"
        echo "$git_remote"
    elif [[ "$git_remote" =~ ^git@ ]]; then
        # Convert SSH format (git@host:path) to HTTPS (https://host/path)
        git_remote=$(echo "$git_remote" | rg -oP "(?<=git@).+" | sed 's/:/\//g')
        echo "https://$git_remote"
    else
        # Unknown format, return as-is
        echo "$git_remote"
    fi
}

function get_git_remote_remove_suffix() {
    local git_remote=$(get_git_remote_url | sed 's/\.git//g')
    echo "$git_remote"

}

function get_git_repo_name() {
    local git_remote=$(get_git_remote_remove_suffix)
    local repo_name="${git_remote##*/}"
    echo $repo_name
}

function get_git_org_name() {
    local git_remote=$(get_git_remote_remove_suffix)
    local git_org_name="$(basename "$(dirname "$git_remote")")"

    echo $git_org_name
}

function get_git_branch() {
    local git_branch=$(git branch | grep \* | cut -d ' ' -f2 )

    echo "$git_branch"
}


function get_git_pr_search_url() {
    local git_remote=$(get_git_remote_remove_suffix)
    local git_branch_search=$(get_git_branch | sed 's/\//%2f/g')

    # echo "$git_remote/pulls?q=is%3Apr+is%3Aopen+$git_branch_search"
    echo "$git_remote/pulls?q=is%3Apr+is%3Aopen+head%3A$git_branch_search"
}

function get_git_branch_url() {
    local git_remote=$(get_git_remote_remove_suffix)
    local git_branch=$(get_git_branch)

    echo "$git_remote/tree/$git_branch"
}


