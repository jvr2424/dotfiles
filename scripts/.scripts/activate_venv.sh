# find the activate scripts by searching for activate from the root of the git dir
ACTIVATE_SCRIPT=$(fd --no-ignore --hidden -a --glob activate $(git rev-parse --show-toplevel))
SCRIPT_COUNT=$(echo "${ACTIVATE_SCRIPT}" | wc -l | xargs)
if [ $SCRIPT_COUNT != "1" ]; then
  ACTIVATE_SCRIPT=$(echo "${ACTIVATE_SCRIPT}" | fzf)
fi


source "${ACTIVATE_SCRIPT}"


