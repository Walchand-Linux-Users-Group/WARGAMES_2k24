#!/bin/bash

# Function to reset (delete the .txt.b64 file)
reset() {
    if [ -f "./-/bind_it/.txt.b64" ]; then
        rm -f "./-/bind_it/.txt.b64"
        echo "Game Reset!"
    else
        echo "Error: Game not able to reset"
    fi
}

# Function to stop Docker containers starting with "war"
stop_it() {
    containers=$(docker ps -a --filter "name=^/war" -q)
    if [ -n "$containers" ]; then
        docker stop $containers &> /dev/null
        echo "Game Stopped!"
    else
        echo "Game Stopped!"
    fi
}

# To run as sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please switch to the root user using 'sudo su' and then run the script."
    exit 1
fi

# Parse flags
while getopts ":rs" opt; do
    case $opt in
        r)
            reset
            exit 0
            ;;
        s)
            stop_it
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Ensure the main script is executable
# if [ ! -x "./-/start.sh.x" ]; then
#     echo "The main script ./-/start.sh.x is not executable. Adding execute permissions."
#     chmod +x ./-/start.sh.x
# fi

./-/start.sh.x
