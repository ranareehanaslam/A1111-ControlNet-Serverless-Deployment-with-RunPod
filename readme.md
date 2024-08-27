Here's a beautifully formatted guide for setting up and using Docker with NVIDIA CUDA support:

---

## NVIDIA CUDA and Docker Setup Guide

This guide will walk you through updating your system, installing the NVIDIA CUDA toolkit, configuring Docker for NVIDIA GPU support, and building a Docker image with CUDA capabilities.

### 1. Update Your System

First, ensure your system packages are up to date:

```bash
sudo apt-get update -y
sudo apt-get upgrade -y
```

### 2. Install NVIDIA CUDA Toolkit

Install the NVIDIA CUDA toolkit which provides the necessary libraries and tools for GPU computing:

```bash
sudo apt install -y nvidia-cuda-toolkit
```

### 3. Verify CUDA Installation with Docker

Run the following command to verify that your Docker setup can access the GPU:

```bash
sudo docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
```

This command will run a container with NVIDIA CUDA 11.6.2 and display GPU information using `nvidia-smi`.

### 4. Run a Docker Container with GPU Access

To start an interactive Docker container with GPU access, use:

```bash
docker run --rm --gpus all -it --entrypoint /bin/bash f43834c13049
```

Replace `f43834c13049` with your Docker image ID or name.

### 5. Configure Docker for NVIDIA Runtime

To enable NVIDIA runtime as the default for Docker, edit the Docker daemon configuration:

```bash
sudo nano /etc/docker/daemon.json
```

Add the following JSON configuration:

```json
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "default-runtime": "nvidia"
}
```

Save and exit the editor (`Ctrl+X`, then `Y`, then `Enter`).

### 6. Restart Docker Daemon

After modifying the configuration, restart Docker to apply changes:

```bash
sudo systemctl restart docker
```

### 7. Build a Docker Image with BuildKit

To build a Docker image using BuildKit, set the `DOCKER_BUILDKIT` environment variable to `0`:

```bash
DOCKER_BUILDKIT=0 docker build -t nvidia-test -f Dockerfile .
```

Replace `Dockerfile` with your Dockerfile's name if it's different.

---

### Summary

1. Update and upgrade your system.
2. Install the NVIDIA CUDA toolkit.
3. Verify CUDA installation with Docker.
4. Run an interactive Docker container with GPU access.
5. Configure Docker for NVIDIA runtime.
6. Restart the Docker daemon.
7. Build your Docker image with BuildKit.

Feel free to customize this guide according to your specific needs or Docker setup!

