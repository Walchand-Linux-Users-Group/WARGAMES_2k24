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
    echo "Till then open your cheatsheets, relax and have a sip of commands."
    echo "
    ----------------------------
    Basic Linux Commands Cheatsheet
    ----------------------------
    - ls              : List directory contents
    - cd [dir]        : Change directory
    - pwd             : Print working directory
    - mkdir [dir]     : Create a new directory
    - rmdir [dir]     : Remove an empty directory
    - rm [file]       : Remove a file
    - cp [src] [dst]  : Copy files or directories
    - mv [src] [dst]  : Move or rename files or directories
    - touch [file]    : Create a new file or update the timestamp
    - cat [file]      : Concatenate and display file content
    - grep [pattern] [file] : Search for a pattern in a file
    - find [dir] -name [pattern] : Find files by name
    - chmod [mode] [file] : Change file permissions
    - chown [user]:[group] [file] : Change file owner and group
    - ps              : Display currently running processes
    - top             : Display system tasks and resource usage
    - kill [pid]      : Terminate a process by PID
    - df              : Display disk space usage
    - du [dir]        : Estimate file space usage
    - free            : Display memory usage
    - man [command]   : Display the manual for a command
    - sudo [command]  : Execute a command with superuser privileges
    - curl [url]      : Transfer data from or to a server
    - unzip [file.zip]: Extract files from a zip archive
    - zip [file.zip] [files] : Create a zip archive
    - tar -cvf [archive.tar] [files] : Create a tar archive
    - tar -xvf [archive.tar] : Extract files from a tar archive
    ----------------------------
    "
    
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg0 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg1 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg2 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg3 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg4 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg5 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg6 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg7 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg8 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg9 &> /dev/null
    docker pull ghcr.io/walchand-linux-users-group/wildwarrior44/wargame_finals:warg10 &> /dev/null
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
