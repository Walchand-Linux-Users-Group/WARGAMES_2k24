#!/bin/bash

# Function to handle exit
exit_container() {
    # echo "Exiting the container..."
    kill -TERM $PPID
}

# Set trap for custom signal
trap exit_container SIGUSR1

# Password check
read -p "Please enter the flag of the current level: " password

curr_level=$(sed -n '2p' ./.txt)
curr_level=$(( curr_level + 1 ))

if [[ $curr_level -eq 1 && $password == "Penguin" ]]; then
    sed -i "2s/.*/$curr_level/" ./.txt
    echo "Flag is correct. Level updated to $curr_level."
    echo "Moving to next level..."
    kill -SIGUSR1 $PPID
else
    echo "Incorrect flag! Please try again."
fi
