MODEL=$(rg -t json  -l "model" $(git rev-parse --show-toplevel))


MODEL_COUNT=$(echo "${MODEL}" | wc -l | xargs)

if [ $MODEL_COUNT != "1" ]; then
  MODEL=$(echo "${MODEL}" | fzf)
fi




MODEL_NAME=$(cat  "$MODEL" | jq -c '.model_name')
MODEL_NAME="${MODEL_NAME//\"/}"

MODEL_VERSION=$(cat  "$MODEL" | jq -c '.model_version')
open "https://sketcher-prod.factset.io/models/$MODEL_NAME/$MODEL_VERSION"



