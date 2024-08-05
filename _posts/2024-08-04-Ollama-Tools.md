---
layout: post
title: Ollama Tools
date: 2024-08-04 05:00:00  -500
categories: [ai]
tags: [python,llm,ai,ollama]
image:
  path: /assets/images/headers/ollama-tools.webp
  alt: Ollama Tools
---

# Ollama Tools Ai

Ollama tools is a side project I am working on to allow ollama models to use tools. What is a tool? A function that allows the AI to do something it navitily can't like create a folder and file on your locally machine. You can ask the AI to preform a certain task and based on the function you have created enable the AI to preform a task using tools. Some of the newer models like llama3.1 and llama3-groq-tool-use work well preforming these tasks. 

The goal is to create a large tools class that the Ai is aware of and can use one or more as needed based on a chat session. I have also added a vector databse with similarity score so the AI can referance previous tasks and conversations. Some of the next steps are to add new tools, add a way to drop any document into the folder and prompt the AI a certain way and it can use a tools to create RAG knowledge set and understand your data better.



![Ollama AI Logo](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/ef22576a-7bfe-4a35-9549-df3946ce6c00/public)

## Overview

Ollama Tools AI is a work-in-progress project focused on implementing advanced AI functionalities, including function calling and tool usage. This project aims to provide a robust and flexible framework for AI-driven tasks and interactions.

## Features

- **Function Calling**: Seamlessly integrate and call various functions to perform tasks.
- **Tool Usage**: Utilize different tools for enhanced AI capabilities.
- **Web Search**: Use searXNG or Tavily for web searches
- **Create**: The AI will create folders and files, read files, list files, delete files, web search and more..
- **DB Similarity**: Every chat and tool use is saved in DB for future context aware AI responses.


```yaml
# API Keys
TAVILY_API_KEY=tvly-

# Models
OLLAMA_MODEL=llama3-groq-tool-use
EMBED_MODEL=nomic-embed-text

# Search Configuration
SEARCH_PROVIDER=SEARXNG
SEARCH_RESULTS_LIMIT=5

# URLs
OLLAMA_URL=http://127.0.0.1:11434
SEARXNG_URL=http://192.168.70.48:4000

# Database Configuration
DB_DIR=./chromadb  # database location realitive to current directory
N_CONTEXTS=3   # Number of contexts to retrieve from DB - you can adjust this for testing
SIMILARITY_THRESHOLD=0.7  # Adjust this value to control context relevance (lower is more strict)

# Debug print statements in terminal False or True
DEBUG_MODE=False

```
Install dependencies 

`pip install -r requirements.txt`


## Usage

```bash
python ol.py
```


## screenshots

![name](https://github.com/bigsk1/ollama-tools/raw/main/images/tav2.png)

---
Search results 

![terminal](https://github.com/bigsk1/ollama-tools/raw/main/images/tav.png)


## Github Repo

[ollama-tools-github](https://github.com/bigsk1/ollama-tools)