FROM osrf/ros:jazzy-desktop

ENV DEBIAN_FRONTEND=noninteractive

# =========================================================
# Ubuntu + ROS2 Packages
# =========================================================
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    cmake \
    flex \
    bison \
    nano \
    vim \
    usbutils \
    udev \
    ttyd \
    iputils-ping \
    net-tools \
    can-utils \
    ros-jazzy-navigation2 \
    ros-jazzy-nav2-bringup \
    ros-jazzy-slam-toolbox \
    ros-jazzy-teleop-twist-keyboard \
    ros-jazzy-robot-state-publisher \
    ros-jazzy-joint-state-publisher-gui \
    ros-jazzy-xacro \
    ros-jazzy-rviz2 \
    ros-jazzy-ros-gz \
    ros-jazzy-ros-gz-sim \
    && rm -rf /var/lib/apt/lists/*

# =========================================================
# PlatformIO
# Install as root so student can use "pio" directly
# =========================================================
RUN pip3 install --break-system-packages platformio

# =========================================================
# Student User
# =========================================================
RUN useradd -ms /bin/bash student && \
    usermod -aG dialout student && \
    echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER student
WORKDIR /home/student

# =========================================================
# ROS2 Workspace
# This workspace is mounted by docker-compose
# =========================================================
RUN mkdir -p /home/student/ros2_ws/src

# =========================================================
# micro-ROS Setup Workspace
# =========================================================
RUN mkdir -p /home/student/micro_ros_ws/src

# =========================================================
# Clone micro-ROS setup
# =========================================================
RUN git clone -b jazzy \
    https://github.com/micro-ROS/micro_ros_setup.git \
    /home/student/micro_ros_ws/src/micro_ros_setup

# =========================================================
# Install micro-ROS dependencies
# =========================================================
RUN sudo apt-get update && \
    rosdep update && \
    rosdep install \
    --from-paths /home/student/micro_ros_ws/src \
    --ignore-src \
    -y \
    --skip-keys microxrcedds_agent \
    --skip-keys micro_ros_agent \
    --skip-keys clang-tidy

# =========================================================
# Build micro-ROS setup
# =========================================================
RUN /bin/bash -c \
    "source /opt/ros/jazzy/setup.bash && \
     cd /home/student/micro_ros_ws && \
     colcon build --packages-select micro_ros_setup"

# =========================================================
# Source micro-ROS setup
# =========================================================
RUN /bin/bash -c \
    "source /opt/ros/jazzy/setup.bash && \
     source /home/student/micro_ros_ws/install/setup.bash && \
     ros2 run micro_ros_setup create_agent_ws.sh"

# =========================================================
# Build micro-ROS Agent
#
# create_agent_ws.sh creates the source tree at:
# /home/student/src/uros
#
# Therefore build from /home/student using:
# colcon build --base-paths src/uros
#
# The resulting Agent install is:
# /home/student/install
# =========================================================
RUN /bin/bash -c \
    "source /opt/ros/jazzy/setup.bash && \
     cd /home/student && \
     colcon build --base-paths src/uros"

# =========================================================
# Verify micro-ROS Agent
#
# Docker build will FAIL if micro_ros_agent is not available.
# =========================================================
RUN /bin/bash -c \
    "source /opt/ros/jazzy/setup.bash && \
     source /home/student/install/setup.bash && \
     ros2 pkg executables micro_ros_agent"

# =========================================================
# Pre-download ESP32 Platform for PlatformIO
# =========================================================
RUN pio pkg install -g -p espressif32

# =========================================================
# Auto source ROS2 + micro-ROS + micro-ROS Agent
# =========================================================
RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/student/.bashrc && \
    echo "source /home/student/micro_ros_ws/install/setup.bash" >> /home/student/.bashrc && \
    echo "source /home/student/install/setup.bash" >> /home/student/.bashrc

# =========================================================
# Entrypoint
# =========================================================
COPY --chown=student:student entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["bash"]
