## Get the latest model from the downloads folder
NEW_MODEL_NAME=$(find ~/Downloads -type f -name "*.json" -exec stat -f "%m %N" {} + | sort -n | tail -n 1 | awk '{print $2}')
NEW_MODEL_FILENAME=${NEW_MODEL_NAME#*FILENAME=}

if [[ -z $NEW_MODEL_FILENAME ]]; then
  echo "new model filename: '${NEW_MODEL_FILENAME}' not found. Exiting"
  exit 1
else
  echo "new model filename: '${NEW_MODEL_FILENAME}'"
fi

## Get model name from the local relative src/model folder
# OLD_MODEL_NAME=$(find src/model -type f -name "*.json" -printf "TIMESTAMP_MILLISECONDS=%T@ TIMESTAMP=%Tc FILENAME=%p\n" | sort -n | tail -n 1)
OLD_MODEL_NAME=$(find src/model -type f -name "*.json" -exec stat -f "%m %N" {} + | sort -n | tail -n 1 | awk '{print $2}')
OLD_MODEL_FILENAME=${OLD_MODEL_NAME#*FILENAME=}

if [[ -z $OLD_MODEL_FILENAME ]]; then
  echo "old model filename: '${OLD_MODEL_FILENAME}' not found. Exiting"
  exit 1
else
  echo "old model filename: '${OLD_MODEL_FILENAME}'"
fi

## Copy from the downloads to the src/model folder
COPY_COMMAND="cp \"$NEW_MODEL_FILENAME\" \"$OLD_MODEL_FILENAME\""
eval "$COPY_COMMAND"
echo "copied: '${NEW_MODEL_FILENAME}' to '${OLD_MODEL_FILENAME}'"
