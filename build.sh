#!/bin/bash

# Function to ask a yes/no question
ask_question() {
    while true; do
        read -p "$1 (y/n): " answer
        case $answer in
            [Yy]* ) return 0;;  # Yes
            [Nn]* ) return 1;;  # No
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Question prompt
ask_question "Do you want the gpu-enabled image?"

# Check the response and run the appropriate command
if [ $? -eq 0 ]; then
    echo "Building the NVIDIA image..."
    # Build nvidia image [robobase:nvidia]
    docker build -f docker/Dockerfile.nvidia\
        -t robobase:nvidia\
        --rm\
        .

else
    echo "Building the non-NVIDIA image..."
    # Build non-nvidia image [robobase:nogpu]
    docker build -f docker/Dockerfile\
        -t robobase:nogpu\
        --rm\
        .

fi
