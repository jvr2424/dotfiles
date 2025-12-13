source "$HOME/.dotfiles/.env"

function download_fio_data() {
    # platform login
    local tempfile=$(mktemp)

    curl -n "https://$FIO_API_ENDPOINT/apps" -o "$tempfile"
    echo "$tempfile"
}




function get_fio_app_url() {
    local git_repo_name=$(get_git_repo_name | tr "_" "-")
    local tempfile=$(download_fio_data)
    echo "$tempfile"

    local fio_git_url="git@$FIO_API_ENDPOINT:$git_repo_name.git"
    echo "$fio_git_url"


    
    # get the app names that match the git repo name
    # local jq_res=$(cat $tempfile | jq -c --arg git_org_name "$git_org_name" --arg git_repo_name "$git_repo_name" -r 'sort_by(.lastModified) | reverse | map(.iacs[] | select(( .config.github.org == $git_org_name ) and ( .config.github.repo == $git_repo_name ))) | .[0]')
    local fio_app_name=$(cat "$tempfile"  | jq -rc --arg fio_git_url "$fio_git_url" '.[]  | select(.git_url == $fio_git_url) | .name')


    rm "$tempfile"

    echo "$FIO_BASE_URL/apps/$fio_app_name"
}



