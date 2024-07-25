#!/bin/bash

clear

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
    d[CURR_LEVEL]=0
    echo "${d[USERNAME]}" >> "$SCRIPT_DIR/bind_it/.txt"
    echo "${d[CURR_LEVEL]}" >> "$SCRIPT_DIR/bind_it/.txt"

    base64 "$SCRIPT_DIR/bind_it/.txt" > "$SCRIPT_DIR/bind_it/.txt.b64"
    rm "$SCRIPT_DIR/bind_it/.txt"
}

# Get game images
pull_Levels(){
    echo "Patience is the key! Pulling Levels..."
    # sudo apt install shc &> /dev/null
    # docker pull wildwarrior44/warr1 &> /dev/null
    # docker pull wildwarrior44/warr2 &> /dev/null
    docker pull pranavg1203/wargames_levels:start &> /dev/null
    docker tag pranavg1203/wargames_levels:start wildwarrior44/war1 &> /dev/null
    echo "Level 1 Pulled"
    # docker pull pranavg1203/wargames_levels:cowsaymooo &> /dev/null
    # docker tag pranavg1203/wargames_levels:cowsaymooo wildwarrior44/war2 &> /dev/null
    # docker pull pranavg1203/wargames_levels:Binary_file &> /dev/null
    # docker tag pranavg1203/wargames_levels:Binary_file wildwarrior44/war2 &> /dev/null
    # docker pull pranavg1203/wargames_levels:tar &> /dev/null
    # docker tag pranavg1203/wargames_levels:tar wildwarrior44/war2 &> /dev/null
    docker pull pranavg1203/wargames_levels:Networking &> /dev/null
    docker tag pranavg1203/wargames_levels:Networking wildwarrior44/war2 &> /dev/null
    echo "Level 2 Pulled"
    docker pull pranavg1203/wargames_levels:rickroll &> /dev/null
    docker tag pranavg1203/wargames_levels:rickroll wildwarrior44/war3 &> /dev/null
    echo "Level 3 Pulled"
    # docker pull pranavg1203/wargames_levels:curl_level &> /dev/null
    # docker tag pranavg1203/wargames_levels:curl_level wildwarrior44/war4 &> /dev/null
    echo "Pull Complete"
}

if [ -f "$SCRIPT_DIR/bind_it/.txt.b64" ]; then
    # get_Docker
    decoded_content=$(base64 -d "$SCRIPT_DIR/bind_it/.txt.b64")
    username=$(echo "$decoded_content" | sed -n '1p')
    curr_level=$(echo "$decoded_content" | sed -n '2p')
else
    get_Docker
    get_User
    pull_Levels
fi

# Call start_exit.sh with parameters
clear

echo "Welcome to wargames Level $(( curr_level + 1 ))" 

"$SCRIPT_DIR/start_exit.sh" "$username" "$curr_level"
