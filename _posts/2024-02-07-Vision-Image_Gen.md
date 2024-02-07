---
layout: post
title: Vision Image Gen Ui
date: 2024-02-03 05:00:00  -500
categories: [python]
tags: [windows,linux,streamlit]
image:
  path: /assets/images/headers/vision_gen.webp
  alt: Vision Image Gen
---

## AI Image Generator

This project leverages OpenAI's GPT Vision and DALL-E models to analyze images and generate new ones based on user modifications. It provides two interfaces: a web UI built with Streamlit for interactive use and a command-line interface (CLI) for direct script execution.
Features

-    Image Analysis: Automatically describes images using GPT-4 Vision.
-    Image Generation: Generates modified images based on user inputs using DALL-E 3.
-    Web Interface: Interactive web UI for easy operation.
-    CLI: Command-line version for script or batch processing.

![Vision Image Gen](https://imagizer.imageshack.com/img924/4660/6TcFez.jpg)


### How it Works:
 - The app first downloads the image from the provided URL or path locally and analyzes it using the pre-trained AI model gpt-4-vision-preview to generate a description.
- You're then given the opportunity to modify this description to guide the image generation process, the original description from the vision model and your included description are used.
- Finally, the app uses DALL-E 3 to generate a new image 1790x1024 based on the modified description.
- You can see the original image and then newly created image. Right click to save. 


{% include embed/youtube.html id='Eh7atfdpRAo' %}
📺 [Watch Video](https://www.youtube.com/watch?v=Eh7atfdpRAo)



## Installation

Tested in Python 3.11.4

Clone the repository to your local machine:

```bash
git clone https://github.com/bigsk1/vision-image-gen.git
cd vision-image-gen
```

Install the required dependencies:

pip install -r requirements.txt

## Usage

To use the Web UI

To start the web interface, run:

```bash
streamlit run vision_image_gen_ui_local.py
```

Navigate to the URL provided by Streamlit,  http://localhost:8501, in your web browser. Enter you Open AI API Key or Have your Open Ai Api key added to your system enviroment variables in PATH


-    Upload an Image: Use the provided input to upload an image or specify an image URL.
-    View Analysis: See the AI-generated description of the image.
-    Modify and Generate: Enter modifications to the original description and generate a new image.
-    View and Save: The generated image will be displayed, and you can save it locally.

## CLI Version

The CLI version allows you to process images directly from your terminal.

```bash
python vision_image_gen.py
```


## Using Streamlit Cloud Sharing

Use the vision_image_gen_ui.py for Streamlit Cloud sharing, in the settings just add 

```bash
[openai]
api_key = "sk-paste-your-api-key"
```
 the ui and ui_local are basiclly the same file but the api functions differently due to streamlit's setup

## Example of output

```python
==================================================
Vision Response:
==================================================
The image shows a computer terminal interface with ASCII art and text. At the top would be ASCII art resembling a face with a pattern of "#" and "." characters. Below it, within a minimalist window frame, is a navigation menu with options depicted as a pixel-style globe icon labeled "sumfetch," a document icon labeled "ABOUT," a link icon labeled "Website," a folder icon labeled "This Repo," and a series of contact methods including an email address, GitHub URL, and Twitter handle, all associated with the username "bigsk1". The central feature is a bold ASCII art logo or emblem saying "BIGSK1" inside a stylized circular border.

For a text-to-image model, you could describe it as follows:

"Create an image of a dark computer terminal screen with a pixelated face made out of ASCII characters at the top. Include a stylized ASCII art logo that says 'BIGSK1' in the center, enclosed in a circular patterned border. Below the logo, depict a simple user interface with text and monochrome icons signifying navigation options, including a globe for 'sumfetch,' a document for 'ABOUT,' a link chain for 'Website,' and a folder for 'This Repo.' Add additional details

==================================================
User's Modification Input:
==================================================
make it in the style of an american flag

==================================================
Final Prompt Sent to DALL-E 3:
==================================================
The image shows a computer terminal interface with ASCII art and text. At the top would be ASCII art resembling a face with a pattern of characters. Below it, within a minimalist window frame, is a navigation menu with options depicted as a pixel-style globe icon labeled "sumfetch," a document icon labeled "ABOUT," a link icon labeled "Website," a folder icon labeled "This Repo," and a series of contact methods including an email address, GitHub URL, and Twitter handle, all associated with the username "bigsk1". The central feature is a bold ASCII art logo or emblem saying "BIGSK1" inside a stylized circular border.

For a text-to-image model, you could describe it as follows:

"Create an image of a dark computer terminal screen with a pixelated face made out of ASCII characters at the top. Include a stylized ASCII art logo that says 'BIGSK1' in the center, enclosed in a circular patterned border. Below the logo, depict a simple user interface with text and monochrome icons signifying navigation options, including a globe for 'sumfetch,' a document for 'ABOUT,' a link chain for 'Website,' and a folder for 'This Repo.' Add additional details make it in the style of an american flag
```

Example image in the original_image folder this is were your downloaded images will end up.  

The generated_images folder is were the new Dalle generated image will end up.

This is a work in progress, more to add soon.