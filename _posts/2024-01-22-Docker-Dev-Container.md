---
layout: post
title: Docker for AI Development
date: 2024-1-22 05:00:00  -500
categories: [docker]
tags: [windows,wsl,linux,ai,docker,docs]
image:
  path: /assets/images/headers/dockerdev.webp
  alt: Docker Developement AI Logo
---

## Docker-Based Nvidia / Python / Node Development Environment 💻

Docker is an amazing tool that lets you create isolated environments called "containers" for your development projects. Think of it like having a tiny, fully-functional computer inside your main computer where you can play around, build things, and not worry about messing up your main system.
Why Use Docker for Development?

-    Isolation: Each project can have its own environment with specific tools and versions, without affecting other projects.
-   Consistency: The environment is consistent, so it works the same way on everyone's computer.
-    Simplicity: Easy to share and replicate environments, making collaboration smoother.
-    Safety: Experiment without risking your main system.

Example Projects

-    Web Development: Perfect for building web apps using technologies like Node.js, Python Flask, or Ruby on Rails.
-    Data Science: Great for data projects using Jupyter Notebooks with Python, R, or Julia.
-    Machine Learning: Ideal for machine learning projects using TensorFlow, PyTorch, and CUDA for GPU support.

---

> *Note: Create a folder that we will use to map from your host computer to inside the docker container. So when you are working inside the container your work can be saved inside this mapped folder, the examples below we call it workspace*
{: .prompt-info }

## Who is this for?

- Using linux or Windows (wsl) with Nvidia RTX GPU and want a dev enviroment
- Install projects like Stable Diffusion, ComfyUI, Oobabooga Text Gen Webui or other GPU required local LLM in isolation
- Looking to build using Python, Node.js and might want to be able to use your Nvidia GPU on projects and want an isolated enviroment, one that can be removed and another started quickly. 
- Music or Voice generation using GPU acceleration, like MusicGen, AudioGen, Bark or Whisper
- Building an AI App with AI Agents doing tasks on your file system, keep em caged up so they don't mess something up.

## Works well with

- VScode  - you can comment out the vs-code server in Dockerfile to add a locally running web based version or use your own vscode with it 
- Docker Desktop to manage image and container. 
- Portainer, Dockage or other docker managment systems
- In WSL Ubuntu or Debian


##  Create a Dockerfile

So I am going to show a Dockerfile I use as a general purpose work enviroment. It is for those using Nvidia GPU's and any kind of AI work like with Stable Diffusion or running a local LLM. This container is about 20GB so just be aware. Also change the ENV timezone to your timezone in the Dockerfile 

### What does this Dockerfile do?

Base Image: NVIDIA CUDA on Ubuntu

-    NVIDIA CUDA Toolkit: Your Docker image is based on an NVIDIA CUDA image (nvidia/cuda:12.3.1-devel-ubuntu22.04), which includes the CUDA Toolkit. CUDA (Compute Unified Device Architecture) is a parallel computing platform and API model created by NVIDIA. It allows software developers to use a CUDA-enabled graphics processing unit (GPU) for general purpose processing (an approach termed GPGPU, General-Purpose computing on Graphics Processing Units).
-    Ubuntu 22.04: This is a Linux distribution based on Debian, known for its reliability and ease of use. It's a popular choice for development environments.

Programming Languages and Tools

-    Python 3.11: A high-level, interpreted programming language known for its readability and wide range of applications in web development, data science, artificial intelligence, and more. Also includes the nightly pytorch version 12.1
-    Node.js: An open-source, cross-platform, back-end JavaScript runtime environment that executes JavaScript code outside a web browser.
-    JupyterLab: An interactive development environment for Jupyter notebooks, code, and data. It's widely used in data science for its ease of plotting and data manipulation.

Development Tools

-    Git: A distributed version-control system for tracking changes in source code during software development.
-    Curl: A command-line tool for transferring data with URLs, used in scripts or for testing APIs.
-    Vim and Nano: Text editors in the Linux environment. Vim is known for its efficiency and powerful features, while Nano is appreciated for its simplicity.

Additional Packages

-    Build-Essential: A package that includes compilers and libraries essential for compiling software. It typically includes GCC/g++, make, and other utilities.
-    FFmpeg: A complete, cross-platform solution to record, convert, and stream audio and video.

Configuration

-    Timezone Setting: You can set the timezone to your preferred region, which is important for logs, scheduled tasks, and time-sensitive applications.

Docker Container Features

-    Volume Mounting: The ability to mount a directory from your host machine to the Docker container, ensuring data persistence and easy file access.
-    Port Mapping: Exposing specific ports for services like JupyterLab to be accessible from the host machine.

## Dockerfile

This Docker image provides a robust, isolated development environment with support for GPU-accelerated applications, making it ideal for a wide range of projects from web development to machine learning. With the inclusion of JupyterLab, it's also well-suited for interactive data exploration and analysis.

```dockerfile
# Use an NVIDIA CUDA developer image based on Ubuntu 22.04
FROM nvidia/cuda:12.3.1-devel-ubuntu22.04

# Set the timezone to America/Los_Angeles
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install necessary packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    git \
    curl \
    vim \
    nano \
    wget \
    libffi-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    xz-utils \
    tk-dev \
    libncurses5-dev \
    libncursesw5-dev \
    zlib1g-dev \
    ffmpeg # Adding FFmpeg

# Install Python 3.11 from source
RUN wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tar.xz && \
    tar -xf Python-3.11.0.tar.xz && \
    cd Python-3.11.0 && \
    ./configure --enable-optimizations && \
    make -j 8 && \
    make altinstall

# Upgrade pip for Python 3.11
RUN python3.11 -m pip install --upgrade pip

# Set Python 3.11.0 as the default Python version
RUN ln -sf /usr/local/bin/python3.11 /usr/bin/python3 && \
    ln -sf /usr/local/bin/python3.11 /usr/bin/python

# Install PyTorch
RUN python3.11 -m pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu121

# Install additional Python tools
RUN python3.11 -m pip install jupyterlab

# Install Node.js (Current Version)
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs

# Install code-server (VSCode server) - optional if using Remote - Containers
# RUN curl -fsSL https://code-server.dev/install.sh | sh

# Clean up APT when done
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /workspace

# Set up JupyterLab (optional, but useful for a dev environment)
EXPOSE 8888

# Expose port for code-server (optional)
# EXPOSE 8080

# Default command (can be overridden)
CMD ["/bin/bash"]
```

##  Build Your Docker Image

Next, you build a Docker image from your Dockerfile. This image is like a snapshot of your environment. Run the command in the same directory as your Dockerfile

```bash
docker build -t dev_work .
```

Use this command to start the container and keep it running. Make sure to add your correct path to your workspace folder. Type pwd in your terminal if unsure.

```bash
docker run -it \
           --gpus all \
           --name dev_work_container \
           --restart unless-stopped \
           -v /home/path/to/your/workspace:/workspace \
           -p 8888:8888 \
           dev_work \
           tail -f /dev/null
```

To get inside the container and run 

```bash
docker exec -it dev_work_container /bin/bash
```

That's it your in, find your workspace folder and inside you can make a new folder for each project you like to work on, also you can just run another container from same image just change the name of it in docker run command like dev_work_container2 , ect.. 

When inside the container if you want to use a jupyter notebook server use the below command

```bash
jupyter-lab --ip=0.0.0.0 --allow-root --NotebookApp.token='' --port=8888
```

I like to use the above because I can use Docker Desktop on windows to stop and start the container at anytime, like only when I want to use it, and the jupyter service isn't running full time. Also when you stop the jupyter service your container doesn't stop. You don't need jupyter it is optional and up to you but can come in handy running cells. 

## Open in VSCode 

Install the Microsoft Remote Development extention pack. Then ctl+shift+P and type in:  Dev Containers: Attach to running container. Boom your in.

Inside the dev_work container type nvidia-smi you should see something similar to let you know your GPU is available to be used.

```bash
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 545.37.02              Driver Version: 546.65       CUDA Version: 12.3     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 4090        On  | 00000000:01:00.0  On |                  Off |
|  0%   38C    P8              20W / 450W |   1239MiB / 24564MiB |      1%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|  No running processes found                                                           |
+---------------------------------------------------------------------------------------+

```

If you don't see the above make sure your host has the latest Nvidia drivers 

CUDA Toolkit in the Container: The CUDA Toolkit, included in the NVIDIA Docker image, is a collection of tools, libraries, and APIs that enable developers to create software that can perform computations on the GPU. This toolkit inside the container works seamlessly with the host's NVIDIA drivers.

Here is a breakdown of the Nvidia Image that is used when building this Dockerfile:

-    CUDA Toolkit: This is the primary feature of the image. The CUDA Toolkit includes the CUDA runtime and development libraries needed to develop CUDA-enabled applications. It's essential for writing and running software that directly interfaces with the GPU for parallel processing tasks.

-    cuDNN (CUDA Deep Neural Network Library): Some of the NVIDIA CUDA images include cuDNN, which is a GPU-accelerated library for deep neural networks. cuDNN is used extensively in deep learning frameworks like TensorFlow and PyTorch.

-    Other CUDA Libraries: Depending on the specific image, it might also include additional CUDA libraries like cuBLAS (for linear algebra operations), cuFFT (for Fast Fourier Transforms), and others. These libraries provide optimized GPU implementations of standard algorithms which are widely used in scientific computing and machine learning.

-    Compatibility with NVIDIA Drivers: These images are designed to work with the NVIDIA drivers installed on your host machine. The container uses the host's GPU resources through NVIDIA's runtime and drivers.

You can always search for another type of Nvidia Image on the hub and replace it in the Dockerfile!  [https://hub.docker.com/r/nvidia/cuda/tags](https://hub.docker.com/r/nvidia/cuda/tags)

## Pytorch usage

** During the image build we switch to using Python 3.11.0 instead of Nvidia's prebuilt image with python 3.10.12. However you have the option to use python 3.10.12 also if you like however in testing pytorch doesn't seem to work with it so by default we enabled 3.11.0.

To test you can use in jupyter notebook or in terminal in your contrainer 
"python" and then paste the code

```python
import torch
print("PyTorch Version:", torch.__version__)
print("CUDA Available:", torch.cuda.is_available())
print("CUDA Version:", torch.version.cuda)
print("Number of GPUs:", torch.cuda.device_count())
```
You should get back if working correctly

- PyTorch Version: 2.3.0.dev20240122+cu121
- CUDA Available: True
- CUDA Version: 12.1
- Number of GPUs: 1


```python
import torch
print(torch.version.cuda)
print(torch.cuda.is_available())
```
- 12.1
- True

You can also make a python file call pytorch_test.py


```python
# pytorch_test.py
import torch

def test_pytorch_cuda():
    # Check if CUDA is available
    if torch.cuda.is_available():
        print("CUDA is available. Testing with a simple operation.")

        # Create a random tensor
        x = torch.rand(5, 3)
        print("Original Tensor:\n", x)

        # Move the tensor to GPU
        x = x.cuda()
        print("Tensor on CUDA:\n", x)

        # Perform a simple addition operation
        y = x + 1
        print("Tensor after addition:\n", y)

        print("PyTorch and CUDA are working correctly!")
    else:
        print("CUDA is not available. Please check your installation.")

if __name__ == "__main__":
    test_pytorch_cuda()
```
and running the command

```bash
python3 pytorch_test.py
```

```bash
CUDA is available. Testing with a simple operation.
Original Tensor:
 tensor([[0.8696, 0.6349, 0.9674],
        [0.4257, 0.2892, 0.3230],
        [0.9859, 0.4811, 0.2655],
        [0.2030, 0.1596, 0.3838],
        [0.9341, 0.3455, 0.1313]])
Tensor on CUDA:
 tensor([[0.8696, 0.6349, 0.9674],
        [0.4257, 0.2892, 0.3230],
        [0.9859, 0.4811, 0.2655],
        [0.2030, 0.1596, 0.3838],
        [0.9341, 0.3455, 0.1313]], device='cuda:0')
Tensor after addition:
 tensor([[1.8696, 1.6349, 1.9674],
        [1.4258, 1.2892, 1.3230],
        [1.9859, 1.4811, 1.2655],
        [1.2030, 1.1596, 1.3838],
        [1.9341, 1.3455, 1.1313]], device='cuda:0')
PyTorch and CUDA are working correctly!
```

## Tensorflow

[https://www.tensorflow.org/install/pip](https://www.tensorflow.org/install/pip)

If needed you can install tensorflow with GPU use 

```bash
pip install tensorflow
```
and then check was installed correctly

```bash
python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
```


## Github

[https://github.com/bigsk1/dev_work](https://github.com/bigsk1/dev_work)