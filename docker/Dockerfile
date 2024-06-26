# This image allows you to have a Ubuntu 20.04 + ROS Noetic setup.
# You can mount the path to the 'robotdev' repository in your host
# machine to the same path in the container. We ask you to use the
# same username in the container as in your host machine. This
# simplifies the maintenance of the 'robotdev' repository.
# This setup relies on the nice ros:noetic image provided
# on Docker Hub.
# /author: Kaiyu Zheng
# /modified: Ryan Roche

FROM ros:noetic

# do this to avoid hanging
ENV DEBIAN_FRONTEND=noninteractive
# Install software
RUN apt-get clean
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y emacs
RUN apt-get install -y sudo
RUN apt-get install -y python3-pip
RUN apt-get install -y net-tools
RUN apt-get install -y iputils-ping
RUN apt-get install -y git
RUN apt-get install -y python3-virtualenv
RUN apt-get install -y gdb
RUN apt-get install -y mlocate
RUN apt-get install -y openssh-client openssh-server
RUN apt-get install -y ros-noetic-desktop-full
RUN apt-get install -y ros-noetic-rviz-imu-plugin
RUN apt-get install -y ros-noetic-navigation
RUN apt-get install -y ros-noetic-ros-control ros-noetic-ros-controllers
RUN apt-get install -y ros-noetic-interactive-marker-twist-server
RUN apt-get install -y ros-noetic-joy
RUN apt-get install -y ros-noetic-twist-mux
RUN apt-get install -y ros-noetic-teleop-twist-joy
RUN apt-get install -y ros-noetic-depthimage-to-laserscan
RUN apt-get install -y python3-catkin-tools
RUN apt-get install -y python3-osrf-pycommon

# Create directories for driver/project code
RUN mkdir /code

# Different shell color
RUN echo "export PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]$ '" >> $HOME/.bashrc

# Automatically source ros noetic setup script
RUN echo "source /opt/ros/noetic/setup.bash" >> $HOME/.bashrc

# print some info on start
RUN echo "echo -e 'Welcome! You are now in a docker container ().'" >> $HOME/.bashrc
RUN echo "echo -e \"Docker ID: $(basename $(cat /proc/1/cpuset))\"" >> $HOME/.bashrc
CMD ["bash"]
