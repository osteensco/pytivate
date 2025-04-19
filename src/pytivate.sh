#!/usr/bin/env bash



# exit on error
set -e

VENV_NAMES=("venv" ".venv" "env" ".env")

active_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "$VIRTUAL_ENV"
    else
        echo "false"
    fi
}

# base command
cmd=(find "$PWD" -type d)

# iterate through possible names and add them to the command
for dir in "${VENV_NAMES[@]}"; do
    cmd+=(-name "$dir" -o)
done

# remove the last or operator from the command
unset 'cmd[-1]'

echo ${cmd[@]}
# pipe output to fzf and capture it
selection=$("${cmd[@]}" | fzf)

# verify activation script exists
if [ ! -f "$selection/bin/activate" ]; then
    echo "$selection/bin/activate was not found!"
    exit 1
fi

# handle already active virtual environments
if [[ "$(active_venv)" != "false" ]]; then
    echo "$(active_venv) is already active."
    if [[ "$(active_venv)" = "$selection" ]]; then
        exit 1
    fi
fi

# Confirm activation
while true; do
    read -p "Activate $selection? (y/n): " answer
  case "${answer,,}" in
    y) source "$selection/bin/activate"; break;;
    n) echo "Virtual environment not activated"; break;;
    *) echo "Invalid response, please enter 'y' or 'n'";;
  esac
done



