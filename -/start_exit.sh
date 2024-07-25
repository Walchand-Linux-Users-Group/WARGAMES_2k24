#!/bin/bash

# Function to start the level
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

start_Level() {
    local user=$1
    local curr_l=$2
    local container_name="war$(( curr_l + 1 ))"

    if docker ps -a --filter "name=$container_name" --format "{{.Names}}" | grep -q "$container_name"; then
        echo "Container '$container_name' already exists. Starting and attaching to it..."
        docker start "$container_name" &> /dev/null
        docker exec -it "$container_name" /bin/bash
    else
        docker run --hostname "$user" --user root -v /var/run/docker.sock:/var/run/docker.sock --mount type=bind,source="$SCRIPT_DIR/bind_it",target=/etc/app -it --name "$container_name" wildwarrior44/war$(( curr_l + 1 )) /bin/bash -c "cd ~ && /bin/bash"
    fi
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <curr_level>"
    exit 1
fi

start_Level "$1" "$2"

# After the container exits
if [ $? -ne 93 ]; then
    docker rm -f war$(( $2 + 1 ))
    echo "Container exited successfully."
    $SCRIPT_DIR/start.sh
else
    containers=$(docker ps -a --filter "name=^/war" -q)
    if [ -n "$containers" ]; then
        docker rm -f $containers &> /dev/null
        if [ $? -eq 0 ]; then
            echo "Game Stopped!"
        else
            echo "Error: Failed to stop some containers."
        fi
    else
        echo "No 'war' containers found."
    fi
fi

# Alias for move command
# alias move='bash /etc/app/move.sh'
