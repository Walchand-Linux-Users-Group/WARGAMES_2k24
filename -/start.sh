#!/bin/bash

clear

# To run as sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please switch to the root user using 'sudo su' and then run the script."
    exit 1
fi

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
        if sudo systemctl restart docker &> /dev/null; then
            echo "Docker restarted using systemctl."
        else
            sudo snap restart docker &> /dev/null
            echo "Docker restarted using snap."
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
}

# Get game images
pull_Levels(){
    echo "Patience is the key! Pulling Levels..."
    sudo apt install shc &> /dev/null
    docker pull wildwarrior44/war1 &> /dev/null
    docker pull wildwarrior44/war2 &> /dev/null
    echo "Pull Complete"
}

if [ -f "$SCRIPT_DIR/bind_it/.txt" ]; then
    username=$(sed -n '1p' "$SCRIPT_DIR/bind_it/.txt")
    curr_level=$(sed -n '2p' "$SCRIPT_DIR/bind_it/.txt")
    
else
    get_Docker
    get_User
    pull_Levels
    
fi

# Call start_exit.sh with parameters
echo "Welcome to wargames Level $(( curr_level + 1 ))" 


"$SCRIPT_DIR/start_exit.sh.x" "$username" "$curr_level"
