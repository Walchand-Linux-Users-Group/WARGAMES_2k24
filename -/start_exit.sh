#!/bin/bash

# Function to start the level
start_Level(){
    local user=$1
    local curr_l=$2
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

    if docker ps -a --filter "name=war$(( curr_l + 1 ))" --format "{{.Names}}" | grep -q "war$(( curr_l + 1 ))"; then
        echo "Container 'war$(( curr_l + 1 ))' already exists. Starting and attaching to it..."
        docker start war$(( curr_l + 1 ))
        docker attach war$(( curr_l + 1 ))
    else
        chmod +x "$SCRIPT_DIR/bind_it/startup.sh"

        docker run --hostname "$user" --user root --mount type=bind,source="$SCRIPT_DIR/bind_it",target=/etc/app -it --name war$(( curr_l + 1 )) wildwarrior44/war$(( curr_l + 1 )) /etc/app/startup.sh
    fi
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <curr_level>"
    exit 1
fi

# Call the function with the provided arguments
start_Level "$1" "$2"

# After the container exits
echo "Container exited successfully. Running next script..."
./start.sh.x
