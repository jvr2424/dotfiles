source "$HOME/.dotfiles/.env"

function download_service_catalog_data() {
    local tempfile=$(mktemp)

    curl "$SERVICE_CATALOG_API_ENDPOINT" -o "$tempfile"
    echo "$tempfile"
}



function get_service_catalog_container_url() {
    local git_remote=$(get_git_remote_remove_suffix)
    local tempfile=$(download_service_catalog_data)

    local jq_res=$(cat $tempfile | jq -c --arg git_remote "$git_remote" -r '.[] |  .containerCodeRepositories[] | select(.repoUrl == $git_remote)')
    local sc_container_id=$(echo $jq_res | jq -c -r '.id')
    local sc_project_id=$(echo $jq_res | jq -c -r '.projectId')

    rm "$tempfile"

    echo "$SERVICE_CATALOG_BASE_URL/projects/$sc_project_id/containers/$sc_container_id"
}

function get_service_catalog_pipeline_url() {
    local git_org_name=$(get_git_org_name)
    local git_repo_name=$(get_git_repo_name)
    local tempfile=$(download_service_catalog_data)

    # get the pipelines that match the repo and org. sort by most recent and take the first one
    local jq_res=$(cat $tempfile | jq -c --arg git_org_name "$git_org_name" --arg git_repo_name "$git_repo_name" -r 'sort_by(.lastModified) | reverse | map(.iacs[] | select(( .config.github.org == $git_org_name ) and ( .config.github.repo == $git_repo_name ))) | .[0]')
    local sc_pipeline_id=$(echo $jq_res | jq -c  -r '.id')
    local sc_project_id=$(echo $jq_res | jq -c  -r '.ownerProjectId')


    rm "$tempfile"

    echo "$SERVICE_CATALOG_BASE_URL/projects/$sc_project_id/pipelines/$sc_pipeline_id"
}



