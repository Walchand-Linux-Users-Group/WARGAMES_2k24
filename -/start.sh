#!/bin/bash

clear

# Global variable for curr_level
curr_level=-1

# To run as sudo
# if [ "$(id -u)" -ne 0 ]; then
#     echo "This script must be run as root. Please switch to the root user using 'sudo su' and then run the script."
#     exit 1
# fi

# Determine the script's directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Check for Docker 
get_Docker(){
    if ! command -v docker &> /dev/null; then
        echo "Please Wait..."
        echo "Updating..." 
        sudo apt update &> /dev/null
        echo "Installing Docker..."
        sudo snap install docker &> /dev/null
        echo "Done."
    else
        echo "Docker already exists"
        # Check if Docker is active using systemctl or snap
        if sudo systemctl restart docker &> /dev/null; then
            echo "Docker started using systemctl."
        else
            sudo snap restart docker &> /dev/null
            echo "Docker started using snap."
        fi
    fi
}

# Get username and store for further use
get_User(){
    while true; do
        read -p "Please enter your name (Ex: First_Last): " username
        len=${#username}
        if [ $len -eq 0 ]; then
            echo "Username cannot be empty. Please enter a valid username."
        else
            break
        fi
    done

    touch "$SCRIPT_DIR/bind_it/.txt"
    declare -A d
    d[USERNAME]=$username
    d[CURR_LEVEL]=$curr_level
    echo "${d[USERNAME]}" >> "$SCRIPT_DIR/bind_it/.txt"
    echo "${d[CURR_LEVEL]}" >> "$SCRIPT_DIR/bind_it/.txt"

    base64 "$SCRIPT_DIR/bind_it/.txt" > "$SCRIPT_DIR/bind_it/.txt.b64"
    rm "$SCRIPT_DIR/bind_it/.txt"
}

# Get game images
pull_Levels(){
    echo "Patience is the key! Pulling Levels..."
    docker pull wildwarrior44/wargame_finals:warg0 &> /dev/null
    echo "Demo Pulled"
    docker pull wildwarrior44/wargame_finals:warg1 &> /dev/null
    echo "Level 1 Pulled"
    docker pull wildwarrior44/wargame_finals:warg2 &> /dev/null # level
    echo "Level 2 Pulled"
    docker pull wildwarrior44/wargame_finals:warg3 &> /dev/null
    echo "Level 3 Pulled"
    docker pull wildwarrior44/wargame_finals:warg4 &> /dev/null
    echo "Level 4 Pulled"
    docker pull wildwarrior44/wargame_finals:warg5 &> /dev/null
    echo "Level 5 Pulled"
    docker pull wildwarrior44/wargame_finals:warg6 &> /dev/null
    echo "Level 6 Pulled"
    docker pull wildwarrior44/wargame_finals:warg7 &> /dev/null
    echo "Level 7 Pulled"
    docker pull wildwarrior44/wargame_finals:warg8 &> /dev/null
    echo "Level 8 Pulled"
}

if [ -f "$SCRIPT_DIR/bind_it/.txt.b64" ]; then
    # get_Docker
    decoded_content=$(base64 -d "$SCRIPT_DIR/bind_it/.txt.b64")
    username=$(echo "$decoded_content" | sed -n '1p')
    curr_level=$(echo "$decoded_content" | sed -n '2p')
    echo $curr_level
else
    get_Docker
    get_User
    pull_Levels
fi

# Call start_exit.sh with parameters
clear

echo "Welcome to wargames Level $(( curr_level + 1 ))" 
if [ ! -x "$SCRIPT_DIR/start_exit.sh" ]; then
    # echo "The main script ./-/start.sh.x is not executable. Adding execute permissions."
    chmod +x $SCRIPT_DIR/start_exit.sh
fi

"$SCRIPT_DIR/start_exit.sh" "$username" "$curr_level"
