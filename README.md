# ROS2 Course Jazzy + RViz (WSL2)

Docker Image สำหรับนักเรียน ใช้งานบน

- Windows 11
- WSL2 Ubuntu 24.04
- Docker Desktop
- ROS2 Jazzy
- RViz2
- USB Support

## ติดตั้ง

### Clone

```bash
git clone https://github.com/ros2gorobotics/ros2-course-jazzy-rviz.git
cd ros2-course-jazzy-rviz
```

### เปิด Container

```bash
docker compose up -d
docker exec -it ros2_jazzy_rviz bash
```

### ทดสอบ RViz

```bash
rviz2
```

### ทดสอบ ROS2

```bash
ros2 run demo_nodes_cpp talker
```

อีก Terminal

```bash
ros2 run demo_nodes_py listener
```

### ตรวจสอบ USB

```bash
lsusb
ls /dev/ttyUSB*
ls /dev/ttyACM*
```
