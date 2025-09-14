---
title: Docker for ROS2
author: jay
date: 2025-09-14 03:10:25 +0200
categories: [Blogging, Tutorial]
tags: [docker, ros2, containerization, nvidia, jetson]
render_with_liquid: false
toc: true
description: Efficient ROS2 development with Docker containers and GPU acceleration using ros2_containers package.
---

## Why Docker for ROS2?

ROS2 development suffers from dependency hell, version conflicts, and environment inconsistencies. Docker solves these problems:

- **Isolation**: Each project gets its own clean environment
- **Reproducibility**: Same container works everywhere
- **GPU Support**: NVIDIA acceleration with minimal overhead
- **No System Pollution**: Keep your host OS clean

## The ros2_containers Package

A CLI tool for building and running ROS2 containers with automatic GPU support and GUI forwarding.

### Installation

```bash
git clone https://github.com/JayamuruganRavikumar/ros2_containers
cd ros2_containers
# Follow installation instructions in README
```

### Basic Usage

```bash
# List available configurations
ros2-container list

# Build a container
ros2-container build humble nvidia

# Run with GUI support
ros2-container run humble nvidia

# Run with custom workspace
ros2-container run humble nvidia --workspace ~/ros2_ws
```

### Architecture-Specific Examples

**For x86_64 systems:**
```bash
# Build for perception workloads
ros2-container build humble nvidia perception

# Run with all GPUs
ros2-container run humble nvidia perception
```

**For ARM64/Jetson:**
```bash
# Build for Jetson platform
ros2-container build foxy jetson

# Run with MediaPipe support
ros2-container run foxy jetson mediapipe
```

## Key Features

### GPU Acceleration
Automatic NVIDIA GPU passthrough with proper driver capabilities:

```bash
# Automatic GPU detection and configuration
docker run --runtime=nvidia --gpus all \
  -e NVIDIA_VISIBLE_DEVICES=all \
  ros2-app
```

### GUI Applications
X11 forwarding for visualization tools:

```bash
# Run RViz2 or Gazebo seamlessly
ros2-container run humble nvidia
rviz2  # Works inside container
```

### Multi-Stage Builds

Optimized container images with minimal size:

```dockerfile
# Build stage
FROM ros:humble-devel as builder
COPY src/ /workspace/src/
RUN colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# Runtime stage (smaller image)
FROM ros:humble-ros-base
COPY --from=builder /workspace/install /opt/ros/overlay
```

## Docker Compose for Multi-Node Systems

```yaml
version: '3.8'
services:
  perception:
    image: ros2:humble-nvidia-mediapipe
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./src:/workspace/src
    network_mode: host

  navigation:
    image: ros2:humble-nvidia-navigation
    depends_on:
      - perception
    network_mode: host
```

## Troubleshooting

**GPU not detected:**
```bash
# Check NVIDIA runtime
docker run --rm --gpus all nvidia/cuda nvidia-smi

# Verify container toolkit
sudo systemctl restart docker
```

**Permission errors:**
```bash
# Fix X11 permissions
xhost +local:docker
```

**DDS communication issues:**
```bash
# Use host networking for complex setups
docker run --rm --it --gpus all --network host nvidia/cuda 
```

## Conclusion

Docker containers provide a clean, reproducible environment for ROS2 development with minimal performance overhead. The ros2_containers package simplifies this workflow with automatic GPU support and platform-specific optimizations.

For complex robotics projects, containerization isn't just convenient—it's essential for maintaining sanity across development teams and deployment environments.
