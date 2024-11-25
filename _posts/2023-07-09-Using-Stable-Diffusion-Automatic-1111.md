---
title: How to Install Stable Diffusion for Windows 10/11
date: 2023-07-09 12:00:00  -500
categories: [ai]
tags: [docs,ai,stable-diffusion,art,images,windows]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/stableD.webp
---

### Using Stable Diffusion on your own PC Hardware

Automatic 1111 stable Diffusion webui is a great way to get started and run it on your own hardware. You should have a decent GPU, AMD or better yet a Nividia RTX 2080 or newer. 

You can find the github repo here [Stable Diffusion Github](https://github.com/AUTOMATIC1111/stable-diffusion-webui)

1. Prepare Your Computer: Before you begin, your computer needs to have the right tools. You'll need to install Python [Python 3.10](https://www.python.org/downloads/release/python-3106/) ( if you don't have it already ) , which is like the language your computer needs to speak to run this program. You also need something called git, which is a way for your computer to talk to GitHub, where the program lives.

2. For Python, you need version 3.10.6. Even if there are newer versions, you need to stick with this one because the program we're running needs it. Make sure to check the box that says "Add Python to PATH" during installation. This lets your computer know where to find Python when it needs it.


3. Get the Program: Now that your computer has the tools, we can go get the program. We're going to use git to download (or "clone") the program from GitHub. If you don't have git you can get it here [Install Git here](https://git-scm.com/download/win)  Open the command prompt (you can search for 'cmd' in your start menu), then type in 

```bash
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git 
```
and press Enter. This tells git to go to that website (github) and download the program. You can also create a new Folder anywere on your hard drive and in the file explorer address click in it and type cmd, it will open command prompt right to that path and then you can do the git clone.

4. Install the Program: After you've downloaded the program, you'll have a new folder called "stable-diffusion-webui" on your computer. In this folder, you'll find a file called webui-user.bat. This is like the instruction manual for your computer. Double-click on this file to run it. You don't need to run it as an administrator.

Open your browser and type in the url box 127.0.0.1:7860 and your ready to start using Stable Diffusion.

Run the Program: Now the program is all set up! Any time you want to run it, just go back to the "stable-diffusion-webui" folder and double-click webui-user.bat. You can also make a shortcut on your desktop to this file.

### A few notes about running the webui-user.bat

You can add different options when starting stable diffusion, as you learn there can be additional options to add when starting SD like --xformers 

Below is an example of what I use

```bash
@echo off

set PYTHON=
set GIT=
set VENV_DIR=
set COMMANDLINE_ARGS= --xformers
git pull
call webui.bat
```

There are a few youtubers that cover stable diffusion content really good, I would check them out for details

https://www.youtube.com/@OlivioSarikas

https://www.youtube.com/@Aitrepreneur

https://www.youtube.com/@sebastiankamph

https://www.youtube.com/@mreflow






