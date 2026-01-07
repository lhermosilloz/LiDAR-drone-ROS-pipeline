#!/usr/bin/env bash
set -e
set -o pipefail

# Config
ROS_IP_ADDR="192.168.1.10"
ROS_MASTER="http://192.168.1.10:11311"
NET_DEV="eth1"

WS_LIVOX="/home/root/ws_livox"
WS_LIO="/home/root/ws_lio"
MAVROS_DIR="/home/mavros_test"
BRIDGE_WS="/home/mavros_test/catkin_ws"

# Environment
source /opt/ros/melodic/setup.bash
export ROS_MASTER_URI="${ROS_MASTER}"
export ROS_IP="${ROS_IP_ADDR}"

# Ensure that eth1 has the right IP
if ! ip -4 addr show dev "${NET_DEV}" | grep -q "${ROS_IP_ADDR}/24"; then
        ip addr add "${ROS_IP_ADDR}/24" dev "${NET_DEV}" || true
fi

# Clean shutdown
pids=()
cleanup() {
        echo "[ros-stack] Caught signal, stopping..."
        for pid in "${pids[@]}"; do
                kill "${pid}" 2>/dev/null || true
        done
}
trap cleanup INT TERM

# roscore
echo "[ros-stack] Starting roscore..."
roscore &
pids+=($!)

# Waiting for master to answer
for i in {1..30}; do
        if rosparam list >/dev/null 2>&1; then
                break
        fi
        sleep 0.2
done

# Livox driver
echo "[ros-stack] Starting livox_ros_driver2..."
source "${WS_LIVOX}/devel/setup.sh"
roslaunch livox_ros_driver2 msg_MID360.launch &
pids+=($!)

# FAST-LIO2
echo "[ros-stack] Starting FAST-LIO2..."
source "${WS_LIO}/devel/setup.sh"
roslaunch fast_lio mapping_mid360.launch &
pids+=($!)

# MAVROS
echo "[ros-stack] Starting MAVROS..."
cd "${MAVROS_DIR}"
./run_mavros.sh &
pids+=($!)

# Bridge node
echo "[ros-stack] Starting fastlio -> mavros bridge..."
source "${BRIDGE_WS}/devel/setup.sh"
rosrun fastlio_mavros_bridge fastlio_to_mavros_odom.py &
pids+=($!)

echo "[ros-stack] All processes started. Waiting..."
wait