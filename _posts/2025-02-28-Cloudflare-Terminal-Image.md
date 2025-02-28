---
title: Cloudflare Terminal Image Generator
date: 2025-02-28 10:30:00 -500
categories: [python]
tags: [python,cloudflare,openai,terminal,image-generation]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/cloudflare-terminal.webp
---

# Cloudflare Terminal Image Generator (`cf`)

A powerful Python utility that lets you generate AI images with OpenAI and instantly upload them to Cloudflare Images—all from your terminal. Type a simple description and get back hosted image URLs in seconds.

![cf-terminal-image](https://imagedelivery.net/WfhVb8dSNAAvdXUdMfBuPQ/68793d07-652f-4d7a-07fc-2e5f65305100/public)

## What Is It?

The Cloudflare Terminal Image Generator (`cf`) is a streamlined command-line tool that combines OpenAI's DALL-E 3 image generation with Cloudflare's image hosting service. It eliminates the traditional workflow of:

1. Going to an AI image generator website
2. Downloading the generated image
3. Uploading to an image host
4. Copying the URL

Instead, you simply run one command with your image description, and the tool handles everything else—giving you ready-to-use image URLs directly in your terminal.

## Key Features

- **Instant Image Generation**: Creates high-quality images using DALL-E 3 (1024×1024 or 1792×1024 widescreen)
- **Automatic Cloudflare Upload**: Uploads generated images to your Cloudflare Images account
- **Terminal-Based Workflow**: No browser or GUI needed—perfect for developers
- **Rich Terminal Interface**: Progress bars and formatted output using the `rich` library
- **Terminal Image Preview**: See a low-resolution preview right in your terminal
- **Image History**: Track all your generated images with timestamps and expiration status
- **Expiration Options**: Set images to auto-expire after 24 hours or 30 days
- **Cross-Platform**: Works on Windows, macOS, and Linux

## How It Works

The tool follows a simple but powerful workflow:

1. You provide an image description via command line
2. The script sends the description to OpenAI's API
3. OpenAI generates the image based on your description
4. The image is uploaded to Cloudflare Images
5. You receive clickable URLs in your terminal
6. The image details are saved to your history file

All of this happens in seconds, with a clean terminal interface showing progress at each step.

## Example Usage

Basic usage is as simple as:

```bash
python cf.py "image of a brown dog with space background"
```

For more options:

```bash
# Generate a widescreen image
python cf.py --wide "futuristic cyberpunk city"

# Create an image that expires after 24 hours
python cf.py --expire 24h "a robot in the rain"

# Combine options for a temporary widescreen image
python cf.py --expire 30d --wide "a space station in orbit"

# View your image generation history
python cf.py --history
```

## Terminal Output

The tool provides a rich terminal interface with:

- Progress indicators for generation and upload
- Formatted output with clickable URLs
- Image preview directly in the terminal (if supported)
- Color-coded status messages


## Setup Process

Setting up the tool requires:

1. **API Keys**: You'll need keys from both OpenAI and Cloudflare
2. **Environment Variables**: Store your keys securely as environment variables
3. **Python Dependencies**: Install the required packages (`requests`, `rich`, `pillow`)
4. **Optional Image Preview Tools**: For Linux users, `viu` or `chafa` enhance the experience

The repository includes detailed setup instructions for all major operating systems.


## Why I Built This

As a developer who frequently needs images for projects, documentation, and blog posts, I found the traditional workflow inefficient. This tool streamlines the process down to a single command, saving valuable time and reducing context switching.

The combination of OpenAI's powerful image generation and Cloudflare's reliable image hosting creates a seamless experience that fits perfectly into a developer's terminal-centric workflow.

## Technical Implementation

The tool is built with Python and leverages several key technologies:

- **OpenAI API**: For DALL-E 3 image generation
- **Cloudflare Images API**: For reliable, CDN-backed image hosting
- **Rich Library**: For beautiful terminal formatting and progress indicators
- **Pillow**: For image processing and terminal preview generation
- **JSON**: For storing and retrieving image history

The code is designed to be modular, making it easy to extend with additional features or adapt to different image generation or hosting services.



## Future Enhancements

I'm planning several enhancements for future versions:

- Support for additional AI image models
- Batch processing of multiple image descriptions
- Image variation generation
- Custom Cloudflare delivery profiles
- Integration with other terminal workflows

## Get Started

Ready to try it yourself? Check out the full project on GitHub:


Follow the setup instructions, and you'll be generating and hosting images from your terminal in minutes! 