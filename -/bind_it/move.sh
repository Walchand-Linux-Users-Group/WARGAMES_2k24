#!/bin/bash


decode_file(){
    base64 -d /etc/app/.txt.b64 > /etc/app/.txt
}

encode_file(){
    base64 /etc/app/.txt > /etc/app/.txt.b64
    rm /etc/app/.txt
}

# Password check
read -p "Please enter the password for next level: " password

decode_file

curr_level=$(sed -n '2p' /etc/app/.txt)
curr_level=$(( curr_level + 1 ))

if [[ $curr_level -eq 1 && $password == "Penguin" ]]; then
    sed -i "2s/.*/$curr_level/" /etc/app/.txt
    encode_file
    echo "Password is correct. Level updated to $(( curr_level + 1 ))."
    echo "You may now exit by either pressing Ctrl + D or type 'exit' (without quotes)."
    exit 0
else
    echo "Incorrect flag! Please try again."
    exit 1
fi
