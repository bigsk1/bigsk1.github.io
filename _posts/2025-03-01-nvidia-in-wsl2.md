---
layout: post
title: NVIDIA in WSL2
date: 2025-03-01 05:21:44 -500
categories: [devops, selfhosting]
tags: [nividia, container, tool]
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/b37b3497-b099-442a-2f81-aef574b12f00/public
---

# NVIDIA Container Toolkit in WSL2 Ubuntu

Setting up NVIDIA's GPU acceleration in Windows Subsystem for Linux (WSL2) unlocks powerful capabilities for developers working with containers. This guide walks you through installing the NVIDIA Container Toolkit in your Ubuntu WSL2 environment, enabling GPU-accelerated Docker containers without dual-booting.

![Inline image 1 related to NVIDIA in WSL2](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/66d492e1-c7a8-47a4-0574-5c4d954f7f00/public)



## Prerequisites

Before diving into the installation process, ensure you have:

1. Windows 10/11 with WSL2 installed and configured
2. Ubuntu distribution running on WSL2 (preferably 20.04 LTS or newer)
3. NVIDIA GPU with up-to-date Windows drivers (minimum 470.xx)
4. Docker installed in your WSL2 environment

> **Note**: WSL2 GPU support requires Windows 10 build 20145 or higher. Check your Windows version by pressing `Win+R`, typing `winver`, and pressing Enter.

## Verifying NVIDIA Driver Support in WSL2

First, let's confirm that your WSL2 environment can access your NVIDIA GPU. Open your Ubuntu WSL2 terminal and run:

```bash
nvidia-smi
```

If properly configured, you should see output displaying your GPU information. If this command fails, you may need to update your Windows NVIDIA drivers or ensure WSL2 GPU passthrough is enabled.

## Installing NVIDIA Container Toolkit

Now let's install the NVIDIA Container Toolkit, which allows Docker containers to leverage your GPU.

### Step 1: Set Up the NVIDIA Repository

Add NVIDIA's package repository to your Ubuntu system:

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
```

Update your package lists:

```bash
sudo apt-get update
```

### Step 2: Install the NVIDIA Container Toolkit

Install the toolkit packages:

```bash
sudo apt-get install -y nvidia-container-toolkit
```

### Step 3: Configure Docker Runtime

![Inline image 2 related to NVIDIA in WSL2](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/23deeb13-6ad6-43b7-d151-11d959295100/public)



The NVIDIA Container Toolkit needs to be configured as a runtime for Docker. Create or modify the Docker daemon configuration file:

```bash
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
```
### Step 4: Restart Docker Service

For the changes to take effect, restart the Docker service:

```bash
sudo service docker restart
```

If you encounter any issues restarting Docker in WSL2, you might need to restart your WSL2 instance:

```bash
wsl --shutdown
```

Then reopen your Ubuntu terminal.

## Testing GPU Support in Containers

Let's verify that containers can now access your GPU:

```bash
docker run --gpus all nvidia/cuda:12.0-base nvidia-smi
```

This command pulls the NVIDIA CUDA container image and runs `nvidia-smi` inside it. If successful, you should see the same GPU information as when running the command directly on your WSL2 instance.

## Common Issues and Troubleshooting

### "Unknown runtime specified nvidia" Error

If you see this error when running a container with `--gpus all`, ensure that:

1. The Docker daemon configuration file is correctly set up
2. Docker service was restarted after configuration
3. The NVIDIA Container Toolkit is properly installed

### Missing Libraries

Sometimes containers might fail with missing library errors. Install additional packages if needed:

```bash
sudo apt-get install -y nvidia-container-runtime
```
### WSL2 GPU Access Issues

If WSL2 cannot access your GPU:

1. Ensure your NVIDIA drivers are updated to the latest version
2. Check that WSL2 GPU support is enabled in Windows features
3. Verify in Windows PowerShell with:

```powershell
wsl --status
```

This should indicate that GPU is enabled for WSL2.

## Advanced Configuration

### Setting Default Runtime

To make NVIDIA the default runtime for all containers:

```bash
sudo tee /etc/docker/daemon.json <<EOF
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
```

### Resource Allocation

Limit GPU memory or specify which GPUs to use:

```bash
# Limit to 1GB memory
docker run --gpus all,capabilities=utility,memory=1gb nvidia/cuda:12.0-base nvidia-smi
```
```bash
# Use specific GPU devices (if you have multiple)
docker run --gpus device=0,1 nvidia/cuda:12.0-base nvidia-smi
```

## Use Cases for GPU-Accelerated Containers in WSL2

With NVIDIA Container Toolkit properly configured in WSL2, you can now:

- Run machine learning workloads with TensorFlow, PyTorch, or other ML frameworks
- Perform GPU-accelerated data processing
- Develop and test CUDA applications
- Execute computer vision tasks with OpenCV GPU acceleration
- Run GPU-intensive simulations

## Conclusion

Installing NVIDIA Container Toolkit in WSL2 Ubuntu creates a powerful development environment that combines Windows' usability with Linux's development capabilities and NVIDIA's GPU acceleration. This setup eliminates the need to dual-boot while providing near-native GPU performance for containerized applications.

The ability to run GPU-accelerated containers in WSL2 represents a significant advancement for developers, data scientists, and researchers who need to leverage NVIDIA GPUs without sacrificing their preferred development environment.

Remember that WSL2 GPU support continues to evolve, so keep your Windows system, WSL2 distribution, and NVIDIA drivers updated to benefit from the latest improvements and features.