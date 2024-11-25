---
title: oobabooga Webui for chat models
date: 2023-08-09 12:00:00  -500
categories: [ai]
tags: [docs,ai,oobabooga,chatbot,llm,windows]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/chat_bot.webp
---

## Gradio Web UI for Text Generation

What Is It?

![image](https://github.com/oobabooga/screenshots/raw/main/print_instruct.png)


### Easy Version

Imagine you have a super-smart robot that can write stories, answer questions, or even chat like a human. This Gradio Web UI is like a remote control for that robot. It's a website where you can tell the robot what to do and see what it writes back.

#### Why Use It?

- **Easy to Use**: It's like playing a video game! You don't need to know how to code to use it.
- **Multiple Modes**: You can use it like a notebook for school, like a chatbox, or even in a default mode that's super simple.
- **Many Smart Robots**: You can switch between different types of smart robots (called models) to see which one you like best.
- **Cool Features**: You can do things like load different settings on-the-fly, or even train a new setting yourself!

#### How to Use It?

#### Step 1: Install It

##### Easy Way

1. Download a ZIP file for your computer (Windows, Linux, macOS, or WSL).
2. Unzip it and click on "start."

#### For Tech-Savvy Kids

- Use something called "Conda" to install it manually. This is a bit complicated but gives you more control.

#### Step 2: Start It

1. Open your computer's command line.
2. Type some commands to go to the folder where you installed it.
3. Type `python server.py` and press Enter.

#### Step 3: Use It

1. Open your web browser and go to `http://localhost:7860/?__theme=dark`.
2. Now you can start using it! Choose a smart robot, type something, and see what it writes back.

#### Extra Tips

- You can download more smart robots from a website called "Hugging Face."
- If you want to update it later, you just need to run some simple commands.

---

### The Technical Details

The project is a Gradio web UI designed for text generation using large language models. It aims to be a comprehensive tool similar to AUTOMATIC1111's stable-diffusion-webui. The UI supports various features:

#### Interface Modes

- Default mode
- Notebook
- Chat

#### Model Support

- Multiple backends like transformers, llama.cpp, ExLlama, AutoGPTQ, and more. Models can be downloaded on [huggingface](https://huggingface.co/TheBloke).

#### Additional Features

- Dropdown for model selection
- On-the-fly LoRA loading and training
- Precise instruction templates for chat mode
- Support for 4-bit, 8-bit, and CPU inference
- Efficient text streaming
- Markdown and LaTeX output

#### Installation

- One-click installers for Windows, Linux, macOS, and WSL.
- Manual installation using Conda is also available.

#### Model Download

- Models can be downloaded from Hugging Face and placed in a specific folder.

#### Starting the Web UI

- Activate the Conda environment and run the server script.

The project is well-documented and offers various customization options, including settings for multi-user mode, model loader, and hardware acceleration.

#### GitHub Repository

[GitHub Link](https://github.com/oobabooga/text-generation-webui)

For more details, users can refer to the project's [documentation](https://github.com/oobabooga/text-generation-webui/tree/main/docs)

#### Watch a YouTube Video

Watch a YouTube video on how to install oobabooga web UI here [youtube install instructions](https://www.youtube.com/watch?v=VPW6mVTTtTc)