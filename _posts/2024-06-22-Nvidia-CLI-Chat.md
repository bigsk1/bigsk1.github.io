---
layout: post
title: Nvidia CLI AI Chat
date: 2024-06-20 05:00:00  -500
categories: [python]
tags: [windows,linux,ai,nvidia,gpt]
image:
  path: /assets/images/headers/nvidia-cli.webp
  alt: Nvidia CLI Chat 
---


# NVIDIA CLI Chat

I bring you yet another amazing way to chat with AI, this time using nvidia NIMS! I built this terminal app to be able to test out some of the massive and state of the art LLM's from Nvidia. All you need is a free developer API key, anyone can sign up and get free credits to play around with the models.



This project provides a command-line interface (CLI) chat application using various NVIDIA models through the NVIDIA API. The application allows users to interact with different language models, each with specific parameters, and have conversations directly in the terminal.


![Nvidia_cli_chat](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/ed68cc10-23f8-455a-39f2-e097ed8f8c00/public)

## Features

- Supports multiple NVIDIA models with specific parameters.
- Interactive chat interface using `rich` for better terminal formatting.
- Configuration via environment variables.
- API key management for secure access to NVIDIA models.

## Prerequisites

- Python 3.6 or higher
- Dev account with Nvidia (it's free) for your API Key https://build.nvidia.com/explore/discover

## Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/bigsk1/nvidia_cli_chat.git
   cd nvidia_cli_chat
   ```

2. **Create a Virtual Environment:**

   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```

3. **Install Dependencies:**

   ```bash
   pip install -r requirements.txt
   ```

4. **Set Up Environment Variables:**

   Rename .env.sample to .env:

   ```plaintext
   API_KEY="your_single_api_key"

   MISTRAL_LARGE="mistralai/mistral-large"
   LLAMA3_70B="meta/llama3-70b-instruct"
   PHI_3_MINI_128K="microsoft/phi-3-mini-128k-instruct"
   ARCTIC="snowflake/arctic"
   GRANITE_34B_CODE="ibm/granite-34b-code-instruct"
   ```

   Replace `your_single_api_key` with your actual personal NVIDIA API key. You can add additional models by just copying the models format in .env and adding them to models.py 

## Usage

1. **Run the Chat Interface:**

   ```bash
   python main.py
   ```

2. **Select a Model:**

   You will be prompted to select a model by number. Each model has a specific name and description to help you choose the appropriate one for your needs.

3. **Interact with the Model:**

   - Type your messages in the terminal.
   - The model will respond with generated text based on your input.

4. **Exit the Chat:**

   - Type `exit` or `quit` to end the chat session.

## Project Structure

```
nvidia_cli_chat/
├── main.py                # Main script to run the chat interface
├── api_handler.py         # Handles API requests to NVIDIA
├── chat_interface.py      # Manages the terminal chat interface
├── models.py              # Defines available models and their parameters
├── .env                   # Environment variables (not included in version control)
├── requirements.txt       # Project dependencies
└── README.md              # Project documentation
```

## Files Overview

- **`main.py`**: The entry point of the application, which initializes the chat interface and manages the interaction loop.
- **`api_handler.py`**: Contains the `NvidiaAPI` class that handles requests to the NVIDIA API.
- **`chat_interface.py`**: Uses `rich` to create an interactive and formatted chat interface in the terminal.
- **`models.py`**: Defines the available models, their descriptions, and parameters. Allows users to select a model at runtime.
- **`.env`**: Stores environment variables including the API key and model identifiers.
- **`requirements.txt`**: Lists the Python packages required to run the application.

## Example 

Code examples in terminal

![nvidia_chat](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/6ccb0a41-cdf1-4465-3f87-0f2364e9a200/public)


## Github Repo

[Nvidia-CLI-Chat](https://github.com/bigsk1/nvidia_cli_chat)