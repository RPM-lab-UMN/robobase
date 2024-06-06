#!/bin/bash

ask_question() {
    while true; do
        read -p "$1: " answer
        case $answer in
            1 ) return 1;;  # Yes
            2 ) return 2;;  # No
            * ) echo "Please answer 1 or 2.";;
        esac
    done
}

# Check for the robobase:nvidia image
echo "🔎 Looking for robobase:nvidia image..."
if docker image inspect robobase:nvidia > /dev/null 2>&1; then
    echo "🐳 NVIDIA image detected!"
    exists_nvidia=true
else
    echo "🚫 NVIDIA image not detected"
    exists_nvidia=false
fi

echo

# Check for the robobase:nogpu image
echo "🔎 Looking for robobase:nogpu image..."
if docker image inspect robobase:nogpu > /dev/null 2>&1; then
    echo "🐳 nogpu image detected!"
    exists_nogpu=true
else
    echo "🚫 nogpu image not detected"
    exists_nogpu=false
fi

echo

# Ask the user which image to run if both are present, or print an error message if neither are found
if [ "$exists_nvidia" = false ] && [ "$exists_nogpu" = false ]; then
    echo "ERROR: Image not found for nvidia OR nogpu."
    echo "HINT: Make sure you've built the image on this machine."
    exit 1

elif [ "$exists_nvidia" = true ] && [ "$exists_nogpu" = true ]; then
    echo "Both robobase:nvidia and robobase:nogpu images were found."
    echo "[1] robobase:nvidia"
    echo "[2] robobase:nogpu"
    ask_question "Please choose which container to run"
    container_to_run=$?

elif [ "$exists_nvidia" = true ]; then
    container_to_run=1

else
    container_to_run=2
fi

# Get XAUTH data to bind X11 for GUI applications
XAUTH=/tmp/.docker.xauth
echo "Preparing Xauthority data..."

xauth_list=$(xauth nlist :0 | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -f $XAUTH ]; then
    if [ ! -z "$xauth_list" ]; then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

echo "Done."

# Run the appropriate container image
if [ "$container_to_run" = 1 ]; then
    echo "💠 Running the NVIDIA robobase image..."
    docker run -it\
        --volume ./:/code/\
        --env "TERM=xterm-256color"\
        --env "DISPLAY=$DISPLAY"\
        --volume /tmp/.X11-unix/:/tmp/.X11-unix:rw\
        --env "XAUTHORITY=$XAUTH"\
        --volume $XAUTH:$XAUTH\
        --privileged\
        --network=host\
        --name="robobase"\
        --runtime=nvidia\
        --gpus all\
        robobase:nvidia

else
    echo "💠 Running the no-gpu robobase image..."
    docker run -it\
        --volume ./:/code/\
        --env "TERM=xterm-256color"\
        --env "DISPLAY=$DISPLAY"\
        --volume /tmp/.X11-unix/:/tmp/.X11-unix:rw\
        --env "XAUTHORITY=$XAUTH"\
        --volume $XAUTH:$XAUTH\
        --privileged\
        --network=host\
        --name="robobase"\
        robobase:nogpu
fi