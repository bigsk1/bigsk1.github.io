---
title: Sig Script - Signature on Images
date: 2023-12-10 12:00:00  -500
categories: [python]
tags: [docs,python,windows] 
image:
  path: /assets/images/headers/sig_script.webp
---



# SigScript

This script automatically adds a signature to all the Stable Diffusion images you generate or any image you want. The idea is to make it easier to brand your images with your own name or alias. You can add a signature to hundreds of thousands of images quickly.

## 🎥 Demo

{% include embed/youtube.html id='_cfz92vdGt0' %} 📺 [Watch Video](https://www.youtube.com/watch?v=_cfz92vdGt0)



## 📌 Prerequisites

- Python 3.10+
- Windows 10/11

## 🚀 Quick Start

## Install Python Virtual Environment

Run `start.bat` to install a Python virtual environment (venv).

## Edit the Script

Open the `scripts/signature.py` file in a text editor like Notepad.

## Set Image Folder Path

Change the following line to point to your images folder.

```python
directory = r'C:\add-your-image-folder-path-here'
```

For example:

```python
directory = r'C:\\Users\\somedude\\Downloads'
```

## Add Your Signature

Add your name or alias to the following line:

```python
signature_text = 'ADD YOUR NAME HERE'
```

For example:

```python
signature_text = '-bigsk1'
```

## Customize Appearance

The default font color is white, but you can change it by modifying the RGB values in the script. You can also change the font, line width, and size.

## Run the Script

Double-click `start.bat` to run the script.

## Output

The signed images will be saved in the `outputs` folder. Original images will not be modified.

## File Naming

If your original image name is `00925-3431573143.png`, the signed image will be saved as `00925-3431573143_signed.png`.

## Supported File Types

- `.png`
- `.jpg`
- `.jpeg`
- `.bmp`
- `.tiff`

> Note: The script supports both upper and lowercase file extensions like \`.PNG\`.



![Sig Script Image](https://imagizer.imageshack.com/img923/5148/UklSgD.jpg)

 

 ## Github repo

 [https://github.com/bigsk1/SigScript](https://github.com/bigsk1/SigScript)