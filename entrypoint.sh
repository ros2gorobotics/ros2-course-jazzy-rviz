#!/bin/bash

source /opt/ros/jazzy/setup.bash

if [ -f /home/student/ros2_ws/install/setup.bash ]; then
    source /home/student/ros2_ws/install/setup.bash
fi

exec "$@"
