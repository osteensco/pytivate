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


# prune command
basecmd="find $PWD \( -type d \( -name 'node_modules' -o -name '.git' "
findcmd="-type d "

# iterate through possible names and add them to the command
for dir in "${VENV_NAMES[@]}"; do
    basecmd+="-o -name $dir "
    findcmd+="-name $dir -o "
done

# combine into one command
cmd="$basecmd\) -prune \) $findcmd"

# remove the last or operator from the command
len=$(printf "%s" "$cmd" | wc -c)
newlen=$((len - 3))
cmd=$(printf "%s" "$cmd" | cut -c1-"$newlen")

# pipe output to fzf and capture it
cmd+="| fzf"

# echo "$cmd"
selection=$(bash -c "$cmd")



# start path validation
echo "Validating paths are correct in the virtual environment"

if [[ ! -f "$selection/pyvenv.cfg" ]]; then
    echo "Error: $selection/pyvenv.cfg was not found!"
    return 1
fi

if [[ "$(grep '^command =' "$selection/pyvenv.cfg" | rev | cut -d ' ' -f1 | rev)" != "$selection" ]]; then
    echo "  Updating command path in pyvenv.cfg..."
    pyloc=$(command -v python || command -v python3)
    sed -i "s|^command = .*|command = $pyloc -m venv $selection|" "$selection/pyvenv.cfg"
fi

for file in "$selection"/bin/activate*; do
    [[ -f "$file" ]] || continue

    case "$(basename "$file")" in
        
        activate)
            if [[ "$(grep '^export VIRTUAL_ENV=' "$file" | cut -d= -f2-)" != "$selection" ]]; then
                echo "  Updating activation script $file"
                sed -i "s|^ *export VIRTUAL_ENV=.*|export VIRTUAL_ENV=$selection|" "$file"
            fi
            ;;

        activate.csh)
            if [[ "$(grep '^ *setenv VIRTUAL_ENV ' "$file" | awk '{print $3}')" != "$selection" ]]; then
                echo "  Updating activation script $file"
                sed -i "s|^ *setenv VIRTUAL_ENV .*|setenv VIRTUAL_ENV $selection|" "$file"
            fi
            ;;

        activate.fish)
            if [[ "$(grep '^ *set -gx VIRTUAL_ENV ' "$file" | awk '{print $4}')" != "$selection" ]]; then
                echo "  Updating activation script $file"
                sed -i "s|^ *set -gx VIRTUAL_ENV .*|set -gx VIRTUAL_ENV $selection|" "$file"
            fi
            ;;
    esac

done

for file in "$selection"/bin/*; do
    [[ -f "$file" && ! -d "$file" ]] || continue
    read -r first_line < "$file"
    if [[ "$first_line" == "#!"*python* && "$first_line" != "#!$selection/bin/python" ]]; then
        echo "  Updating shebang in $file"
        sed -i "1s|^#!.*python.*$|#!$selection/bin/python|" "$file"
    fi 
done
# end path validation



echo "Attempting to activate $selection"

# verify activation script exists
if [ ! -f "$selection/bin/activate" ]; then
    echo "$selection/bin/activate was not found!"
    return 1
fi

# inform user of already active virtual environments
if [[ "$(active_venv)" != "false" ]]; then
    echo "$(active_venv) is already active."
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

