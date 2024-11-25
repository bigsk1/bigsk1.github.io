---
layout: post
title: Perplexica AI
date: 2024-05-28 05:00:00  -500
categories: [docker]
tags: [windows,linux,ai]
image:
  path: /assets/images/headers/perplexica.webp
  alt: Perplexica AI Chat and Search
---

# Perplexica AI Search


## Overview
Perplexica is an AI-powered search engine designed to enhance your search experience by delivering more accurate, context-aware results. Whether you need to find the latest news, dive into a specific subject, or keep track of your favorite topics, uses SearXNG under the hood as a meta search engine!

## A few points about it

1. **AI at the Core**: Perplexica utilizes advanced AI algorithms to provide smarter search results.
2. **User-Centric Design**: Built with the user in mind, Perplexica aims to be as intuitive and helpful as possible.
3. **Community Driven**: Contributions from developers worldwide help shape Perplexica's features and improvements.
4. **Dynamic Updates**: Perplexica continuously evolves, incorporating user feedback and the latest in AI technology.
5. **Focus Modes**: Different focus modes allow you to tailor the search engine to your specific needs, whether it's research, casual browsing, or keeping up with trends.


![Perplexica Search](/assets/images/posts/perplex.webp)


## Key Features

### Advanced Search Capabilities
Perplexica goes beyond simple keyword searches by understanding the context and delivering more relevant results.

### Focus Modes
Customize your search experience with various focus modes:
- **Research**: Deep dives into academic articles and detailed information.
- **Casual Browsing**: Quick and easy searches for everyday use.
- **Trending Topics**: Stay updated with the latest trends and news.
- **Personalized Results**: Tag and save searches for a more personalized experience.

### Local LLM Support
Integrate local Large Language Models (LLMs) to enhance your search capabilities and keep your data secure. Use your local OLLAMA install with Perplexica!



## Configuration
To learn more about configuring Perplexica, check out the project on the github 
[Perplexica Github Repo](https://github.com/ItzCrazyKns/Perplexica)

## Installation

### Prerequisites
Ensure you have the following:
- Node.js (for both front-end and back-end development)
- Docker (optional for production setup)

### Backend Setup
1. Navigate to the root directory of the Perplexica project.
2. Locate the `sample.config.toml` file and rename it to `config.toml`.
3. Fill in the necessary configuration fields in `config.toml`.
4. Run the following command to install dependencies:
    ```bash
    npm install
    ```
5. Start the backend development server:
    ```bash
    npm run dev
    ```

### Frontend Setup
1. Navigate to the `ui` directory.
2. Rename `.env.example` to `.env` and fill in the required frontend-specific variables.
3. Install frontend dependencies:
    ```bash
    npm install
    ```
4. Launch the frontend development server:
    ```bash
    npm run dev
    ```

### Docker Setup
For production environments, you can use Docker to deploy Perplexica easily:

1. Navigate to the root directory.
2. Build and run the Docker containers:
    ```bash
    docker-compose up --build
    ```


### Gluetun and Perplexica 

I was able to get this stack to run and work good, just need to have your VPN providers credentials, then every search or request outside your network is on a VPN.


```yaml
services:
  gluetun:
    image: qmcgaw/gluetun:latest
    container_name: gluetun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    volumes:
      - /home/user/Perplexica/gluetun:/gluetun  # in gluetun folder have servers.json
    environment:
      - VPN_SERVICE_PROVIDER=vpnprovidername
      - OPENVPN_USER=
      - OPENVPN_PASSWORD=
      - SERVER_COUNTRIES=United States
      - SERVER_HOSTNAMES=
      - TZ=America/Phoenix
      - BLOCK_MALICIOUS=on 
      - BLOCK_SURVEILLANCE=on 
      - BLOCK_ADS=on
      - DOT=on
      - FIREWALL_OUTBOUND_SUBNETS=192.168.1.0/24 # if using ollama at host ip of machine
    networks:
      - perplexica-network
    ports:
      - 3001:3001
      - 3000:3000
      - 4000:8080
    restart: unless-stopped

  searxng:
    image: docker.io/searxng/searxng:latest
    volumes:
      - ./searxng:/etc/searxng:rw
    network_mode: 'service:gluetun'
    depends_on:
      - gluetun
    restart: unless-stopped

  perplexica-backend:
    build:
      context: .
      dockerfile: backend.dockerfile
      args:
        - SEARXNG_API_URL=http://localhost:8080  # localhost is important as it's in gluetun's network for DNS
    depends_on:
      - gluetun
      - searxng
    network_mode: 'service:gluetun'
    restart: unless-stopped

  perplexica-frontend:
    build:
      context: .
      dockerfile: app.dockerfile
      args:
        - NEXT_PUBLIC_API_URL=http://localhost:3001/api  # if running on server and accessing from another machine add host ip of server, 192.168.x.x
        - NEXT_PUBLIC_WS_URL=ws://localhost:3001  # # if running on server and accessing from another machine add host ip of server
    depends_on:
      - gluetun
      - perplexica-backend
    network_mode: 'service:gluetun'
    restart: unless-stopped

networks:
  perplexica-network:
```


## Building from Source

### Prerequisites
- Install [Node.js](https://nodejs.org/).
- Ensure you have Docker installed for containerized production setups.

### Steps to Build
1. Clone the Perplexica GitHub repository.
2. Navigate to the root directory and install backend dependencies:
    ```bash
    npm install
    ```
3. Navigate to the `ui` directory and install frontend dependencies:
    ```bash
    cd ui && npm install
    ```

## Using Perplexica

### Getting Started
1. Open your browser and go to `http://localhost:3000` for the frontend interface.
2. Use the search bar to start exploring data with enhanced AI capabilities.
3. Customize your focus mode and adjust settings as needed to tailor the search experience to your needs.

[Perplexica Github Repo](https://github.com/ItzCrazyKns/Perplexica)