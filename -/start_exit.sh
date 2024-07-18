#!/bin/bash

# Function to start the level
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
start_Level() {
    local user=$1
    local curr_l=$2

    if docker ps -a --filter "name=war$(( curr_l + 1 ))" --format "{{.Names}}" | grep -q "war$(( curr_l + 1 ))"; then
        echo "Container 'war$(( curr_l + 1 ))' already exists. Starting and attaching to it..."
        docker start war$(( curr_l + 1 )) &> /dev/null
        docker attach war$(( curr_l + 1 )) &> /dev/null
    else
        docker run --hostname "$user" --user root -v /var/run/docker.sock:/var/run/docker.sock --mount type=bind,source="$SCRIPT_DIR/bind_it",target=/etc/app -it --name war$(( curr_l + 1 )) wildwarrior44/war$(( curr_l + 1 )) /bin/bash -c "cd ~ && /bin/bash"
    fi

}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <curr_level>"
    exit 1
fi

start_Level "$1" "$2"

# After the container exits
if [ $? -eq 0 ]; then
    docker rm -f war$(( $2 + 1 ))
    echo "Container exited successfully."
    $SCRIPT_DIR/start.sh.x
fi

# Alias for move command
# alias move='bash /etc/app/move.sh'

