


FILEPATH=$(realpath "$(find ~/Downloads -type f -print0 | xargs -0 stat -f "%m %N" | sort -nr | head -n 1 | cut -d' ' -f2-)")
echo $FILEPATH | tr -d '\n' | pbcopy
echo $FILEPATH
