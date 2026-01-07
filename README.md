# LiDAR-drone-ROS-pipeline

This repository contains the setup instructions for deploying a ROS stack on VOXL as a systemd service.

## Setup Instructions

### 1. Create the Bringup Script

Create the startup script that will launch the ROS stack:

```bash
sudo mkdir -p /usr/local/bin
sudo vim /usr/local/bin/start_voxl_ros_stack.sh
```

### 2. Make Script Executable

Set the proper permissions for the script:

```bash
sudo chmod +x /usr/local/bin/start_voxl_ros_stack.sh
```

### 3. Test the Script (Optional but Recommended)

Manually test the script before setting up the systemd service:

```bash
sudo /usr/local/bin/start_voxl_ros_stack.sh
```

### 4. Create the Systemd Service

Create the service configuration file:

```bash
sudo vim /etc/systemd/system/voxl-ros-stack.service
```

### 5. Enable and Start the Service

Reload systemd, enable the service for auto-start, and start it:

```bash
sudo systemctl daemon-reload
sudo systemctl enable voxl-ros-stack.service
sudo systemctl start voxl-ros-stack.service
```

## Service Management

To check the status of the service:

```bash
sudo systemctl status voxl-ros-stack.service
```

To stop the service:

```bash
sudo systemctl stop voxl-ros-stack.service
```

To restart the service:

```bash
sudo systemctl restart voxl-ros-stack.service
```

To view service logs:

```bash
sudo journalctl -u voxl-ros-stack.service -f
```
