ACTIVATE_SCRIPT=$(fd --no-ignore --hidden -a --glob activate)
SCRIPT_COUNT=$(echo "${ACTIVATE_SCRIPT}" | wc -l | xargs)
if [ $SCRIPT_COUNT != "1" ]; then
  ACTIVATE_SCRIPT=$(echo "${ACTIVATE_SCRIPT}" | fzf)
fi


source "${ACTIVATE_SCRIPT}"
