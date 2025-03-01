---
layout: post
title: Local AI Powerhouse
date: 2025-03-01 04:40:47 -500
categories: [devops, selfhosting]
tags: [self-hosted, ollama]
image:
  path: https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/f246f88e-0221-4f01-4741-5d5d7d432800/public
---

---

Running powerful AI models locally rather than relying on cloud services offers compelling advantages: enhanced privacy, reduced latency, and freedom from subscription costs. In this guide, we'll explore how to set up Ollama—a lightweight framework for running Large Language Models (LLMs)—on your own infrastructure using Proxmox and Docker.



## Why Self-Host Your AI?

Cloud-based AI services like ChatGPT and Claude are convenient but come with significant drawbacks:

- Your data leaves your control and potentially becomes training material
- Usage costs can add up quickly with regular use
- Service availability depends on provider uptime and policy changes
- Network latency affects real-time applications

Self-hosting LLMs with Ollama addresses these concerns while giving you complete control over your AI infrastructure. While you won't match the performance of cutting-edge models like GPT-4, today's open-source models like Llama 3, Mistral, and Phi-3 deliver impressive capabilities that are more than sufficient for many use cases.

![self-host](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/b361e885-035e-4e8e-bf94-b7001bb56f00/public)

## Prerequisites

Before we begin, ensure you have:

- A Proxmox server with adequate resources (minimum 16GB RAM, preferably 32GB+)
- Basic familiarity with Proxmox administration
- Understanding of Docker fundamentals
- A GPU is highly recommended but not strictly required

> **Note**: While Ollama can run on CPU-only setups, a GPU dramatically improves inference speed. Even modest consumer GPUs like NVIDIA's RTX 3060 or 4060 provide significant acceleration.

## Setting Up the Proxmox Container

We'll start by creating a privileged LXC container in Proxmox that will host our Docker environment:

1. In Proxmox, navigate to your node and select "Create CT"
2. Choose a recent Ubuntu template (22.04 or newer)
3. Allocate resources based on your hardware:
   - CPU: At least 4 cores
   - Memory: Minimum 8GB, preferably 16GB+
   - Disk: At least 50GB (models can be large)
4. Configure networking as appropriate for your environment
5. Under Options, ensure "Privileged container" is checked

After creating the container, we need to make some adjustments for GPU passthrough (if applicable) and Docker compatibility:

```bash
# Edit container configuration
nano /etc/pve/lxc/YOUR_CONTAINER_ID.conf

# Add these lines for Docker compatibility
lxc.apparmor.profile: unconfined
lxc.cgroup2.devices.allow: a
lxc.cap.drop: 
```

For NVIDIA GPU passthrough, add:

```bash
lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file
lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file
```

## Installing Docker

Start your container and connect via SSH or console. Then install Docker:

```bash
# Update system packages
apt update && apt upgrade -y

# Install prerequisites
apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify installation
docker --version
```

If you're using an NVIDIA GPU, install the NVIDIA Container Toolkit:

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

apt update
apt install -y nvidia-container-toolkit
systemctl restart docker
```

![ollama](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/7c9a8658-184a-461d-81e2-07e2edd8b800/public)

## Deploying Ollama with Docker

Now let's deploy Ollama using Docker Compose for easier management. Create a new directory and a docker-compose.yml file:

```bash
mkdir -p ~/ollama
cd ~/ollama
nano docker-compose.yml
```

Add the following content to the file:

```yaml
version: '3'
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ./data:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

> **Note**: Remove the `deploy` section if you're not using a GPU.

Start the Ollama container:

```bash
docker-compose up -d
```

## Managing Models

With Ollama running, you can now pull and run various LLM models. Here are some popular options:

```bash
# Pull the Llama 3 8B model
docker exec -it ollama ollama pull llama3

# Pull a smaller Mistral model
docker exec -it ollama ollama pull mistral

# List available models
docker exec -it ollama ollama list
```

Models are downloaded to the data volume we created, so they'll persist even if you restart the container.

## Interacting with Your Models

You can interact with your models in several ways:

### Command Line

The simplest approach is directly via the command line:

```bash
docker exec -it ollama ollama run llama3
```

This opens an interactive chat session with the specified model.

### REST API

Ollama provides a REST API that's accessible on port 11434. You can use tools like curl to interact with it:

```bash
# Generate a response
curl -X POST http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt": "Explain quantum computing in simple terms"
}'
```

### Web UI Options

While Ollama doesn't include a web interface, several compatible open-source UIs are available:

1. **Open WebUI**: A feature-rich interface with chat history, model management, and more
2. **Ollama Web UI**: A lightweight, single-page application focused on simplicity
3. **LM Studio**: A desktop application that works well with Ollama

Let's set up Open WebUI as an example:

```bash
mkdir -p ~/open-webui
cd ~/open-webui
nano docker-compose.yml
```

Add this content:

```yaml
version: '3'
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:latest
    container_name: open-webui
    restart: unless-stopped
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_API_BASE_URL=http://ollama:11434
    volumes:
      - ./data:/app/backend/data
    depends_on:
      - ollama
    networks:
      - ollama-network

networks:
  ollama-network:
    external: true
```

Create the network and start the container:

```bash
docker network create ollama-network
docker network connect ollama-network ollama
docker-compose up -d
```

Now you can access the web UI at http://your-server-ip:3000.



## Performance Optimization

To get the most out of your self-hosted Ollama setup:

1. **Model Selection**: Choose models that balance capability and resource requirements. Smaller models (7B parameters) run faster but have less capability than larger ones (70B+).

2. **Quantization**: Use quantized models (GGUF format with Q4_K_M or Q5_K_M) for better performance with minimal quality loss.

3. **Context Length**: Limit context length when possible to reduce memory usage and improve response times.

4. **GPU Memory**: For NVIDIA GPUs, monitor memory usage with `nvidia-smi` and choose models that fit within your available VRAM.

5. **System Monitoring**: Use tools like `htop` and `nvidia-smi` to monitor system resources during inference.

## Conclusion

Self-hosting AI with Ollama on Proxmox and Docker provides a powerful, private alternative to cloud-based language models. While it requires more technical setup than simply signing up for a service, the benefits of privacy, cost savings, and complete control make it worthwhile for many users and organizations.

As open-source models continue to improve, the gap between self-hosted and commercial options narrows, making local AI increasingly practical for everyday use. By following this guide, you've taken an important step toward AI sovereignty—running powerful language models on your own terms, under your own control.

Remember that model capabilities and Ollama features are constantly evolving, so check the [official Ollama documentation](https://github.com/ollama/ollama) for the latest updates and best practices.