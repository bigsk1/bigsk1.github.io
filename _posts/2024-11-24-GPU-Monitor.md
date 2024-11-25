---
title: Nvidia GPU Monitor
date: 2024-11-24 12:05:00  -500
categories: [nvidia]
tags: [docker,gpu,monitoring]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/gpu-monitor.webp
---

# GPU Monitor: Your NVIDIA GPU's Best Friend 🎮

Ever wondered what your GPU is up to? Whether you're training ML models, rendering videos, or gaming hard, keeping an eye on your GPU's health is crucial. Enter GPU Monitor - a sleek, real-time dashboard that turns boring metrics into beautiful visualizations.

## Who Needs This?

- **ML Engineers** training models for days (Is that GPU throttling?)
- **Content Creators** rendering their masterpieces (Why is this export taking so long?)
- **Gamers** pushing their hardware to the limit (Is it time to dial back those settings?)

## Why You'll Love It

- **Real-time Metrics**: Temperature, utilization, memory usage, and power consumption at a glance
- **Historical Data**: See how your GPU performs over time (15min to 24hr views)
- **Smart Alerts**: Get notified when your GPU needs attention
- **Clean Interface**: Modern, dark theme dashboard that's easy on the eyes
- **Lightweight**: Uses minimal resources while monitoring
- **Docker-based**: Run it anywhere, no messy installations

## Quick Setup

1. Got Docker? You're halfway there! Just run:
```bash
docker run -d \
  --name gpu-monitor \
  -p 8081:8081 \
  -e TZ=America/Los_Angeles \
  -v /etc/localtime:/etc/localtime:ro \
  -v ./history:/app/history \
  -v ./logs:/app/logs \
  --gpus all \
  --restart unless-stopped \
  bigsk1/gpu-monitor:latest
```

2. Open `http://localhost:8081` in your browser

3. Watch your GPU metrics come alive!


## Cool Features You Might Not Expect

- **Clickable Gauges**: Toggle different metrics on the performance graph
- **Intelligent Alerts**: Set custom thresholds for temperature, utilization, and power
- **Sound Notifications**: Hear when your GPU needs attention (customizable)
- **Browser Notifications**: Stay informed even when the tab isn't active
- **Data Persistence**: Track performance across restarts
- **Mobile Responsive**: Check your GPU from your phone

## Real-world Uses

### For ML Engineers
Track GPU utilization during training runs. Is your model actually using the GPU efficiently? Are you thermal throttling? GPU Monitor helps you optimize your training pipelines.

### For Content Creators
Monitor rendering jobs without constantly checking task manager. Get notified when renders complete or if your GPU is struggling.

### For Gamers
Keep an eye on temperatures during intense gaming sessions. Perfect for overclocking experiments or optimizing game settings.


## Pro Tips
- Set custom alert thresholds based on your GPU's specs
- Use browser notifications for headless setups
- Check historical data to identify performance patterns
- Monitor power efficiency for optimal workloads


## Join the Community

Found a bug? Have a feature request? Want to contribute? Check out our [GitHub repository](https://github.com/bigsk1/gpu-monitor)!

---

Remember: A watched GPU never throttles! 🚀

## Github Readme


![Docker support](https://img.shields.io/badge/docker-supported-blue)
[![Docker Pulls](https://img.shields.io/docker/pulls/bigsk1/gpu-monitor)](https://hub.docker.com/r/bigsk1/gpu-monitor)
[![Docker Image Size](https://img.shields.io/docker/image-size/bigsk1/gpu-monitor)](https://hub.docker.com/r/bigsk1/gpu-monitor)


# Nvidia GPU Dashboard

A real-time lightweight NVIDIA GPU monitoring dashboard built with Docker for easy deployment and cross-platform compatibility.


## Features

- Real-time GPU metrics monitoring
- Interactive web dashboard
- Historical data tracking (15m, 30m, 1h, 6h, 12h, 24h)
- Temperature, utilization, memory, and power monitoring
- Docker-based for easy deployment
- Persist history between new containers
- Real time alerts - sound and notification
- Responsive theme for any size screen
- Toggle gauges on or off to show metrics in graph

## Prerequisites

- Docker
- NVIDIA GPU
- NVIDIA Container Toolkit

## Quick Start

Test to see if you already have the requirements and ready to use. 

```bash
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```
If this failed proceed to [Installation Prerequisites](#installation-prerequisites)



### Using Pre-built Image

```bash
docker run -d \
  --name gpu-monitor \
  -p 8081:8081 \
  -e TZ=America/Los_Angeles \
  -v /etc/localtime:/etc/localtime:ro \
  -v ./history:/app/history \
  -v ./logs:/app/logs \
  --gpus all \
  --restart unless-stopped \
  bigsk1/gpu-monitor:latest
```
Note: Update your timezone to use the correct time
### Using Docker Compose

1. Clone the repository:
```bash
git clone https://github.com/bigsk1/gpu-monitor.git
cd gpu-monitor
```

2. Start the container:
```bash
docker-compose up -d
```

3. Access the dashboard at: [http://localhost:8081](http://localhost:8081)



## Installation Prerequisites


### 1. Ubuntu / Debian / WSL  
Windows users make sure you have wsl with docker an easy way is [Docker Desktop Installation for Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
 
Installing with apt add NVIDIA package repositories

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

### 2. Install nvidia container toolkit

```bash
sudo apt-get update
```
```bash
sudo apt-get install -y nvidia-container-toolkit
```

### 3. Configure Docker with toolkit

```bash
sudo nvidia-ctk runtime configure --runtime=docker
```
The nvidia-ctk command modifies the /etc/docker/daemon.json file on the host. The file is updated so that Docker can use the NVIDIA Container Runtime.


### 4. Restart Docker daemon

```bash
sudo systemctl restart docker
```

### 5. Test to see if installed correctly

```bash
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```


For other distributions, check the [official documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).


## Building gpu-monitor from source

1. Clone the repository:
```bash
git clone https://github.com/bigsk1/gpu-monitor.git
cd gpu-monitor
```

2. Build the image:
```bash
docker build -t gpu-monitor .
```

3. Run the container:
```bash
docker run -d \
  --name gpu-monitor \
  -p 8081:8081 \
  -e TZ=America/Los_Angeles \
  -v /etc/localtime:/etc/localtime:ro \
  -v ./history:/app/history \
  -v ./logs:/app/logs \
  --gpus all \
  --restart unless-stopped \
  gpu-monitor
```

## Configuration

The dashboard is accessible at: [http://localhost:8081](http://localhost:8081)
 by default. To change the port, modify the `docker-compose.yml` file or the `-p` parameter in the docker run command.

--- 

![GPU Monitor Dashboard](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/a081bac1-e86f-4833-91ad-a1d64c994200/public)


## Alternative Setup Method

A setup script is provided for convenience. It checks prerequisites and manages the service:

- If you have issues then make sure `setup.sh` is executable

```bash
chmod +x ./setup.sh
```

---
- Check prerequisites and start the service
```bash
./setup.sh start
```
---
- Stop the service
```bash
./setup.sh stop
```
---
- Restart the service
```bash
./setup.sh restart
```
---
- Check service status
```bash
./setup.sh status
```
---
- View logs
```bash
./setup.sh logs
```

Example of script running
```bash
~/gpu-monitor ./setup.sh start
[+] Checking prerequisites...
[+] Docker: Found
[+] Docker Compose: Found
[+] NVIDIA Docker Runtime: Found
[+] NVIDIA GPU: Found
[+] Starting GPU Monitor...
Creating network "gpu-monitor_default" with the default driver
Creating gpu-monitor ... done
[+] GPU Monitor started successfully!
[+] Dashboard available at: http://localhost:8081
[+] To check logs: docker-compose logs -f
```


## Data Persistence

By default, all data is stored within the container will persist between container rebuilds, if you don't want that then remove volumes, modify the docker run or docker-compose.yml:

```yaml
services:
  gpu-monitor:
    # ... other settings ...
    volumes:
      - ./history:/app/history    # Remove Persist historical data
      - ./logs:/app/logs    # Remove Persist logs
```

## Alerts

You can enable or disable alerts in ui, you can set thresholds for gpu temp, gpu utilization % and watts. Setting are saved in your browser if you make changes you only need to do it once, however you can always modify the code and rebuild the container to make it permanent.

The defaults are: 

```bash
    temperature: 80,  
    utilization: 100,
    power: 300
```

![GPU Monitor Dashboard](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/6799f2b8-aac2-4741-d125-3b4ed7496e00/public)


## Troubleshooting

### Common Issues

1. **NVIDIA SMI not found**
   - Ensure NVIDIA drivers are installed
   - Verify NVIDIA Container Toolkit installation
   - Make sure you can run:  

```bash
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```
If this failed proceed to [Installation Prerequisites](#installation-prerequisites)

2. **Container fails to start**
   - Check Docker logs: `docker logs gpu-monitor`
   - Verify GPU access: `nvidia-smi`
   - Ensure proper permissions

3. **Dashboard not accessible**
   - Verify container is running: `docker ps`
   - Check container logs: `docker logs gpu-monitor`
   - Ensure port 8081 is not in use
4. **TimeStamps don't match your local time**

    - Replace `America/Los_Angeles` with your timezone
[List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

5. **I don't like the alert sound**
    - Replace the .mp3 in the `sounds` folder and name it alert.mp3
    - Getting double sounds from notifications, disable windows notifications or disable it in ui.

## Mobile Layout

![GPU Monitor Dashboard Mobile Temp](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/3b772d51-8bd6-4d77-5147-25b15170a900/public)

![GPU Monitor Dashboard Mobile Stats](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/c0176433-9449-4243-d3cf-835c198f5500/public)

## License
[![License](https://img.shields.io/github/license/bigsk1/gpu-monitor)](https://github.com/bigsk1/gpu-monitor/blob/main/LICENSE)

Docker Scout Score

![Docker Scout](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/969b5bc9-6c2c-44c7-32a8-359287378a00/public)