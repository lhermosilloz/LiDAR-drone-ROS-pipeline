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

## Known Issues

### ROS Topic Publishing Issue

**Problem:** The `/Odometry` and `/mavros/odometry/out` topics are not being published correctly when using the systemd service.

**Observation:** The topics work properly when the script is executed manually, but fail when run through systemd.

**Possible Causes:**
- Environment variables not properly set in systemd context
- User permissions differences between manual and systemd execution
- ROS environment sourcing issues in systemd service
- Network/timing issues during system startup

**Troubleshooting Steps:**
1. Check service logs for errors: `sudo journalctl -u voxl-ros-stack.service -f`
2. Verify environment variables are properly set in the service file
3. Ensure the service runs with appropriate user permissions
4. Add proper ROS environment sourcing to the startup script