#!/bin/bash

source /opt/ros/jazzy/setup.bash

# micro-ROS setup
if [ -f /home/student/micro_ros_ws/install/setup.bash ]; then
    source /home/student/micro_ros_ws/install/setup.bash
fi

# micro-ROS Agent
if [ -f /home/student/install/setup.bash ]; then
    source /home/student/install/setup.bash
fi

# Student ROS2 workspace
if [ -f /home/student/ros2_ws/install/setup.bash ]; then
    source /home/student/ros2_ws/install/setup.bash
fi

exec "$@"
