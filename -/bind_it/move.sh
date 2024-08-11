#!/bin/bash

decode_file(){
    base64 -d /etc/app/.txt.b64 > /etc/app/.txt
}

encode_file(){
    base64 /etc/app/.txt > /etc/app/.txt.b64 
    rm /etc/app/.txt
}

#            1      2      3     4      5       6       7       8        9
passwords=("DEMO" "Q4OS" "MX" "Void" "Bodhi" "antiX" "Solus" "NixOS" "Alpine")

# Password check
read -p "Please enter the password for the next level (or type 'stop' to exit the game): " password

decode_file

# Get the current level
curr_level=$(sed -n '2p' /etc/app/.txt)
curr_level=$(( curr_level + 1 ))

# Get the last password from the file
last_password=$(tail -n 1 /etc/app/.txt)

if [[ $password == "stop" ]]; then
    echo "You may now exit by either pressing Ctrl + D or typing 'exit' (without quotes)."
    echo "Remember! Your progress for this level will be lost"
    exit 93
fi


if [[ $last_password == "${passwords[$((curr_level - 1))]}" ]]; then
    echo "You have already entered the correct password for this level."
    echo "You may now exit by either pressing Ctrl + D or typing 'exit' (without quotes)."
    encode_file
    exit 0
fi

if [[ $curr_level -ge 0 && $curr_level -le ${#passwords[@]} && $password == "${passwords[$((curr_level))]}" ]]; then
    # Update the level and append the password to the file
    sed -i "2s/.*/$curr_level/" /etc/app/.txt
    echo "$password" >> /etc/app/.txt
    encode_file
    echo "Password is correct. Level updated to $((curr_level+1))."
    echo "You may now exit by either pressing Ctrl + D or typing 'exit' (without quotes)."
    exit 0
else
    echo "Incorrect flag! Please try again."
    encode_file
    exit 0
fi
