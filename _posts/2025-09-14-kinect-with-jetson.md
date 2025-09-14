---
title: Using Azure Kinect with Nvidia Jetson
author: jay
date: 2025-09-14 02:50:56 +0200
categories: [Blogging, Tutorial]
tags: [linux, jetson, kinect, camera]
render_with_liquid: false
toc: true
description: Step-by-step guide to set up Azure Kinect camera SDK on Nvidia Jetson Orin Nano with Ubuntu 20.04 and ROS2 Foxy integration.

---

## System Requirements

- Nvidia Jetson Orin Nano
- Ubuntu 20.04 (or compatible)
- USB 3.0 port for Azure Kinect connection
- Sufficient power supply (Azure Kinect requires additional power)

## Setting up Azure Kinect SDK

### For Ubuntu 20.04

Assuming that you have Ubuntu 20.04 running on your Jetson. Unfortunately at the time of writing this, the SDK is not available for Ubuntu 20.04, but the SDK for 18.04 can be made to work on 20.04.

### Step 1: Download and Install Microsoft Repository

```bash
# Download the repo config package
curl -sSL -O https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb

# Install the config package
sudo dpkg -i packages-microsoft-prod.deb

# Clean up
rm packages-microsoft-prod.deb
```

### Step 2: Configure Repository for ARM64

Open the Microsoft repository configuration file:

```bash
sudo nano /etc/apt/sources.list.d/microsoft-prod.list
```

Change the repository path to:
```
deb [arch=arm64] https://packages.microsoft.com/ubuntu/18.04/multiarch/prod bionic main
```

### Step 3: Install Azure Kinect SDK

```bash
# Update package list
sudo apt update

# Install Azure Kinect packages
sudo apt install libk4a1.4 libk4a1.4-dev k4a-tools
```

### Step 4: Set Up Device Permissions

To avoid running as root every time:

```bash
# Download udev rules
sudo wget -O /etc/udev/rules.d/99-k4a.rules https://raw.githubusercontent.com/microsoft/Azure-Kinect-Sensor-SDK/develop/scripts/99-k4a.rules

# Reload udev rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```

### Step 5: Test Installation

```bash
# Launch the Azure Kinect viewer
k4aviewer
```

### For Ubuntu 22.04

You will encounter a dependency problem with libsoundio when trying to install the normal way, since Azure Kinect uses libsoundio1 which is not available in Ubuntu 22.04 repositories.

#### Step 1: Download libsoundio1 Package

For **amd64** architecture:
```bash
wget http://mirrors.kernel.org/ubuntu/pool/universe/libs/libsoundio/libsoundio1_1.1.0-1_amd64.deb
```

For **arm64** architecture (Jetson):
```bash
wget http://ftp.de.debian.org/debian/pool/main/libs/libsoundio/libsoundio1_1.1.0-1_arm64.deb
```

#### Step 2: Install libsoundio1

```bash
# Install the downloaded package (adjust filename for your architecture)
sudo dpkg -i libsoundio1_1.1.0-1_arm64.deb
```

#### Step 3: Install Azure Kinect SDK

```bash
# Update package list
sudo apt update

# Install Azure Kinect packages
sudo apt install libk4a1.4 libk4a1.4-dev k4a-tools
```

#### Step 4: Set Up Device Permissions

```bash
# Download udev rules
sudo wget -O /etc/udev/rules.d/99-k4a.rules https://raw.githubusercontent.com/microsoft/Azure-Kinect-Sensor-SDK/develop/scripts/99-k4a.rules

# Reload udev rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```

#### Step 5: Test Installation

```bash
# Launch the Azure Kinect viewer
k4aviewer
```
>NOTE: I Recommend to use docker for this so that the it may not corrupt the main apt in ubuntu when you try to upgrade.

## Installing the ROS2 Foxy Driver for Azure Kinect

### Prerequisites

Ensure you have ROS2 Foxy installed on your system before proceeding.

### Installation Steps

```bash
# Source the ROS2 underlay
source /opt/ros/foxy/setup.bash

# Clone the Azure Kinect ROS2 driver
git clone https://github.com/microsoft/Azure_Kinect_ROS_Driver.git -b foxy-devel

# Install dependencies
pip3 install xacro
sudo apt install ros-foxy-joint-state-publisher

# Navigate to the workspace
cd Azure_Kinect_ROS_Driver

# Build the package
colcon build

# Source the overlay
source install/setup.bash
```

### Launch the Driver

```bash
# Launch the Azure Kinect driver
ros2 launch azure_kinect_ros_driver driver.launch.py
```

### Visualizing Data

In a separate terminal:

```bash
# Source ROS2 and the workspace
source /opt/ros/foxy/setup.bash
source Azure_Kinect_ROS_Driver/install/setup.bash

# Launch RViz2
rviz2
```

For detailed configuration options, refer to the [usage guide](https://github.com/microsoft/Azure_Kinect_ROS_Driver/blob/foxy-devel/docs/usage.md).

## Troubleshooting

### Common Issues

#### Permission Denied Errors

If you encounter permission errors when accessing the device:

```bash
# Check if the device is recognized
lsusb | grep Microsoft

# Verify udev rules are applied
ls -la /etc/udev/rules.d/99-k4a.rules

# Restart udev service
sudo systemctl restart udev
```

#### K4AViewer Not Opening

If `k4aviewer` fails to start:

```bash
# Check if the device is connected and powered
k4aviewer --verbose

# Ensure USB 3.0 connection
dmesg | grep -i usb
```

#### ROS2 Build Failures

If colcon build fails:

```bash
# Install missing dependencies
sudo apt update
sudo apt install python3-colcon-common-extensions

# Clean and rebuild
rm -rf build install log
colcon build
```

#### Performance Issues

- Ensure adequate power supply (Azure Kinect requires 5V/1.8A)
- Use USB 3.0 port for optimal performance
- Check CPU usage and consider reducing resolution/framerate(Normmally should be able to handle the highest settings)

### Verification Commands

```bash
# Check Azure Kinect SDK version
dpkg -l | grep k4a

# List available ROS2 topics
ros2 topic list

# Monitor topic data
ros2 topic echo /rgb/image_raw
```
