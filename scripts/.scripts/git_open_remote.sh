function get_git_remote_url() {
    local git_remote=$(git remote -v | awk '/origin.*push/ {print $2}' | rg -oP "(?<=git@).+" | sed 's/:/\//g' | xargs echo | (echo -n "https://" && cat))
    echo "$git_remote"
}

function get_git_remote_remove_suffix() {
    local git_remote=$(get_git_remote_url | sed 's/\.git//g')
    echo "$git_remote"

}

function get_git_branch() {
    local git_branch=$(git branch | grep \* | cut -d ' ' -f2 )

    echo "$git_branch"
}


function get_git_pr_search_url() {
    local git_remote=$(get_git_remote_remove_suffix)
    local git_branch_search=$(get_git_branch | sed 's/\//%2f/g')

    echo "$git_remote/pulls?q=is%3Apr+is%3Aopen+$git_branch_search"
}

function get_git_branch_url() {
    local git_remote=$(get_git_remote_remove_suffix)
    local git_branch=$(get_git_branch)

    echo "$git_remote/tree/$git_branch"
}


