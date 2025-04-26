#!/usr/bin/env bash


DEFAULT_NAMES=("venv" ".venv" "env" ".env")

if [ -n "${VENV_NAME:-}" ]; then
    VENV_NAMES=("$VENV_NAME")
else
    VENV_NAMES=("${DEFAULT_NAMES[@]}")
fi

active_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "$VIRTUAL_ENV"
    else
        echo "false"
    fi
}

# workdir="$PWD"
workdir="/mnt/c/Users/ostee/Desktop/Repos/opensauce/pytivate"

# base command
cmd="find $PWD -type d "


# iterate through possible names and add them to the command
for dir in "${VENV_NAMES[@]}"; do
    cmd+="-name $dir -o "
done

# remove the last or operator from the command
len=$(printf "%s" "$cmd" | wc -c)
newlen=$((len - 3))
cmd=$(printf "%s" "$cmd" | cut -c1-"$newlen")

# pipe output to fzf and capture it
cmd+="| fzf"

# echo "$cmd"
selection=$(bash -c "$cmd")

echo "Attempting to activate $selection"

# verify activation script exists
if [ ! -f "$selection/bin/activate" ]; then
    echo "$selection/bin/activate was not found!"
    return 1
fi

# handle already active virtual environments
if [[ "$(active_venv)" != "false" ]]; then
    echo "$(active_venv) is already active."
    if [[ "$(active_venv)" = "$selection" ]]; then
        return 0
    fi
fi



if [ "$1" = "-y" ]; then
    # Skip confirmation
    source "$selection/bin/activate"
else
    # Confirm activation
    while true; do
        printf "Activate %s? (y/n): " "$selection"
        read answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
      case "$answer" in
        y) source "$selection/bin/activate"; break;;
        n) echo "Virtual environment not activated"; break;;
        *) echo "Invalid response, please enter 'y' or 'n'";;
      esac
    done
fi

