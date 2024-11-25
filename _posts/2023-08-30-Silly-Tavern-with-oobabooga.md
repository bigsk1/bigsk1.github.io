---
title: Silly Tavern webui with oobabooga
date: 2023-08-30 12:00:00  -500
categories: [ai]
tags: [docs,ai,oobabooga,silly-tavern,chatbot,llm,windows]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/silly_tavern.webp
---

## Silly Tavern 

What is it?  What does it do?  How to use it? 


## What is SillyTavern?

SillyTavern is a program you can put on your computer or even your Android phone. It's like a special frontend interface where you can talk to computer-generated characters. You can even make your own characters or use ones that other people have made. You will also need a backend that processes the chat models that you load, a Nvidia GPU 2090 and above is recommended. 

## How Does it Work?

SillyTavern is like the "face" of the operation, but it needs a "brain" to actually have conversations. That brain is another program that does all the thinking for the characters. There are different kinds of brains you can use, like OpenAI's GPT, KoboldAI, and more. Here we will be refering to Oobabooga Webui as you can run this on your local computer but there are many options.

## What's Cool About It?

1. **Mobile-Friendly**: You can use it on your phone!
2. **Multi-API**: It can connect to different "brains" for the characters.
3. **Waifu Mode**: Imagine anime-style conversations!
4. **System TTS**: The characters can even "speak" to you.
5. **WorldInfo**: You can create backstories for your characters.
6. **Customizable UI**: Make it look the way you want.
7. **Auto-Translate**: It can speak different languages.
8. **Prompt Options**: You can set up how you want to start conversations.

## How to Get Started?

### Windows Users

- Install NodeJS (it's like the engine that runs the program).
- Use GitHub Desktop to download SillyTavern or just make use you have installed git already
  
- Open a folder where you want to put SillyTavern.


    DO NOT INSTALL INTO ANY WINDOWS CONTROLLED FOLDER (Program Files, System32, etc).

    DO NOT RUN START.BAT WITH ADMIN PERMISSIONS

- Open Command Prompt in that folder and type some commands to set it up. In the file explorer bar type cmd and command prompt will open from that folder, then type
```bash
  git clone https://github.com/SillyTavern/SillyTavern.git
```
cd into SillyTavern

- Double-click `Start.bat` and it will open in your browser.

SillyTavern has a detailed write up here [SillyTavern install on windows](https://docs.sillytavern.app/installation/windows/)

### Linux Users

- Just run the `start.sh` script.


## Can I Use it On My Phone?

Yes, you can! There's a guide for that, and you can use a program called Termux to make it work on Android.


## In-Depth Guide: SillyTavern with Oobabooga's Web UI and Custom Chat Models

## Prerequisites

1. **NodeJS**: Make sure you have NodeJS installed on your system.
   It can be installed here [node.js for windows](https://nodejs.org/en)
2. **Git**: You'll need Git to clone the SillyTavern repository. You can downloaded it here [git_for_windows_and_linux](https://git-scm.com/downloads)
3. **Oobabooga's Web UI**: This is the interface for your custom chat models. Make sure you have it set up and running. [oobaooga install](https://bigsk1.github.io/posts/Oobabooga-webui-for-chat-models/)
4. **Custom Chat Models**: These are the censored and uncensored models you'll want to use for roleplay. Make sure they are compatible with Oobabooga's Web UI.

A few that I recommend are 

TheBloke/MythoMax-L2-13B-GPTQ

TheBloke/llama2_7b_chat_uncensored-GPTQ

TheBloke/Pygmalion-13B-SuperHOT-8K-GPTQ

TheBloke/airoboros-l2-13b-gpt4-m2.0-GPTQ

## Steps for Windows 10/11 install

### 1. Clone SillyTavern Repository

Open your terminal and run:

```bash
git clone https://github.com/SillyTavern/SillyTavern -b release
``````

### 2. Navigate to the SillyTavern Directory

```bash
cd SillyTavern
``````

### 3. Install Dependencies

Run the following command to install the required NodeJS packages:

```bash
npm install
```

### 4. Start SillyTavern

Run the following command to start SillyTavern:

```bash
npm start
```

### 5. Configure Oobabooga's Web UI API Connection
Start Oobabooga webui server first - see here for installing it [Oobabooga Web Ui Install](https://github.com/oobabooga/text-generation-webui) 

In SillyTavern, navigate to the settings and look for the API connections section. Here, you'll need to enter the details for connecting to Oobabooga's Web UI. This usually involves specifying the API endpoint normally on http://127.0.0.1:7860

### 6. Load Custom Chat Models

In Oobabooga's Web UI, make sure you load your chat models. These models should be accessible via the API you just connected to. In the Oobabooga folder look for webui.py and find the CMD_FLAGS and add the line so it looks like this 

```bash
CMD_FLAGS = '--api'
``` 

### 7. Test the Connection

Back in SillyTavern, try initiating a chat to see if it uses your custom model from Oobabooga's Web UI. If everything is set up correctly, your custom model should respond.

### 8. Roleplay Setup

You can now set up your roleplay scenarios, characters, and other settings within SillyTavern. Given that you're using a custom model, you should be able to roleplay without any content restrictions if using an uncensored model. You can also find charactor cards and download images and meta data here at [chub.ai](https://chub.ai/)

## Troubleshooting

- If you encounter issues, check the API logs in both SillyTavern and Oobabooga's Web UI.
- Make sure your custom models are loaded and accessible in Oobabooga's Web UI.
- Ensure that you've correctly entered any required API tokens or authentication details ( if you set a username and password by default this is off ).

---

## The Extras Server

SillyTavern has an extras option which you download separately. You can check it out here [SillyTavern Extras](https://github.com/SillyTavern/SillyTavern-extras)

The extras server you will want to run in a python environment - you will need python 3.11 as of 8/30/23

Create a new virtual environment in the SillyTavern Home folder named 'venv'
```bash
python3 -m venv venv
```
then 
```bash 
venv\Scripts\activate
```
you will see the (venv) now in terminal

then clone the extras repo 

```bash
git clone https://github.com/SillyTavern/SillyTavern-extras.git
```
if your using conda for the python environment then you will already know what to do and this is the best option because you can specify the python version. 

conda create -n sillyextras python=3.11.4

and then conda activate sillyextras

Once you are in your python environment and have cloned the extras repo then, cd SillyTavern-extras ,to get all the extra options use (recommend) 

```bash
pip install -r requirements-complete.txt
```
Open the file called config.conf in a text editor. The file is located in ST's base install folder.
Look for the line that reads const enableExtensions.
Make sure that line has = true, and not = false

to run the extras server it would look like this, just pick the extras you would like to use 

Example: python server.py --enable-modules=caption,summarize,classify

This would enable Image Captioning, Chat Summary, and live updating Character Expressions

## One click Installer on windows for running everything at once
I got tired of having to go and start every server manually when using SillyTavern 

I created a one click installer make a shortcut from it and place on your desktop 

In the SillyTavern Home Directory make a .bat file and modify the path locations and services to fit your needs, this is placed in the sillytavern home directory and once made just right click it and make a shortcut from it and place on your desktop. My installer is using conda for my python environment

This is my working Silly_Tavern_and_Extras.bat file as an example

```bash
@echo off

echo Starting oogabooga web UI...
start cmd /k "X:\oobabooga\oobabooga_windows\start_windows.bat"
timeout /t 5

echo Starting Stable Diffusion Automatic1111 web UI...
cd X:\SD\stable-diffusion-webui
start cmd /k "webui-user.bat"
timeout /t 30

echo Starting SillyTavern server...
pushd %~dp0
start powershell -Command "npm install --no-audit; node server.js"
timeout /t 10

echo Starting SillyTavern Extras server...
cd X:\SillyTavern\SillyTavern-extras
start cmd /k "call C:\Users\dude\miniconda3\Scripts\activate.bat && conda activate sillyextras && python server.py --enable-modules=caption,chromadb,summarize,classify,sd --sd-remote-port 7861"
timeout /t 10

echo Starting Silero API server...
cd X:\SillyTavern\SillyTavern-extras\silero-api-server
start cmd /k "call C:\Users\dude\miniconda3\Scripts\activate.bat && conda activate sillyextras && python -m silero_api_server"

exit
```
make sure python and conda are added to path already and in windows you might have to allow execution policy by using this in admin powershell

```bash
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

If you don't want the .bat file in SillyTavern home folder, which I just make a shortcut once it's there as that is easy and then put on desktop, you could modify, replace your path location as needed. 

pushd %~dp0
start powershell -Command "npm install --no-audit; node server.js"

to 

cd X:\SillyTavern
start powershell -Command "npm install --no-audit; node server.js"

### This .bat file is used for all my self hosted services to startup one right after another

- oobabooga
- stable diffusion for image creation
- Silly Tavern
- Silly Tavern Extras - with all the flags enabled for services
- Silero TTS for voices

Just modify the paths and services as needed for your use case
also shown here [bigsk1 silly-tavern-gist](https://gist.github.com/bigsk1/696f8a10c9d1b9a45100961d141b096f)









