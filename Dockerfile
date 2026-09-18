FROM osrf/ros:jazzy-desktop

ENV DEBIAN_FRONTEND=noninteractive

# =========================
# Ubuntu + ROS2 Packages
# =========================
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
    ros-jazzy-micro-ros-agent \
    ros-jazzy-ros-gz \
    ros-jazzy-ros-gz-sim \
    && rm -rf /var/lib/apt/lists/*

# =========================
# PlatformIO
# =========================
RUN pip3 install --break-system-packages platformio

# =========================
# Student User
# =========================
RUN useradd -ms /bin/bash student && \
    usermod -aG dialout student && \
    echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER student
WORKDIR /home/student

# =========================
# ROS2 Workspace
# =========================
RUN mkdir -p ~/ros2_ws/src

# =========================
# Pre-download ESP32 Platform
# =========================
RUN pio pkg install -g \
    -p espressif32 \
    -t platformio/tool-esptoolpy \
    -t platformio/toolchain-xtensa-esp32 \
    -t platformio/tool-openocd-esp32

# Auto source ROS2
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

COPY --chown=student:student entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash","/entrypoint.sh"]
CMD ["bash"]
