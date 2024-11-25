---
title: Converting Images to ASCII
date: 2023-09-02 12:00:00  -500
categories: [python]
tags: [docs,ascii,images,docker,linux,windows]    # Tag should always be in lowercase
image:
  path: /assets/images/headers/ascii.webp
---

# AIRATS  

## ASCII Image Convertor - How to install

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)


A simple Flask web app and command-line tool to generate ASCII art from an image URL or locally.


Both Web and Command Line usage



Turn any image locally or remotely into ASCII characters.

This project can be found on github here [ascii art generator](https://github.com/bigsk1/airats)

# Installation

## Docker

```bash
docker pull bigsk1/airats:latest
```
or
Build docker image in project root with Dockerfile

Clone the repo then

```bash
cd airats
```


```bash
docker build -t <your_image_name> .
```

```bash
docker run -d -p 5000:5000 <your_image_name>
```


## Linux

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)


1. Clone the repo
   
```bash
git clone https://github.com/bigsk1/airats.git
```

```bash
cd airats
```

2. (Optional) Create a virtual environment and activate it:

```bash
python3 -m venv venv

source venv/bin/activate
```


3. Install the required Python packages:

```bash
pip install -r requirements.txt
```


## Ubuntu 22.04+
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
### If you don't want the virtual environment just make sure you have installed  

```bash
sudo apt install python3 && sudo apt install python3-pip && sudo apt install python3-flask && python3 -m pip install Pillow && python3 -m pip install requests && python3 -m pip install gunicorn
```
run with python3 app.py in the airats folder

```bash
python3 app.py
```
Open a web browser and visit [http://localhost:5000](http://localhost:5000) to access the app.



## Devcontainer VScode

Open in devcontainer and run! Find on localhost:5000


## Windows 64bit install
![Windows 11](https://img.shields.io/badge/Windows%2011-%230079d5.svg?style=for-the-badge&logo=Windows%2011&logoColor=white)

Download .exe from releases here: https://github.com/bigsk1/airats/releases/tag/v1.0

You will most likely get a warning when trying to launch because it is not a signed .exe this is normal.

(optional)  build your own by cloning the win64 branch here:

```bash
git clone --single-branch --branch win64 https://github.com/bigsk1/airats.git
```
see the requirements.txt for what dependencies are needed


# Usage

## Linux

### Web Interface virtual environment in Python



1. Run the Flask app (optional):

```bash
export FLASK_APP=app.py
```
```bash
flask run --host=0.0.0.0
```

2. Open a web browser and visit [http://localhost:5000](http://localhost:5000) to access the app.

3. Enter an image URL and width, then click "Generate ASCII Art" to see the result.





## Command Line



Run any of the following commands from the airats directory:

python3 Main.py <image_url> [-w WIDTH] [-ht HEIGHT]

### Image size can be changed as needed


You can also run an image you have locally using:


python3 Main.py your_image.jpg -w 150 -ht 50

or 

python3 Main.py https://your-image-url.jpeg -w 150 -ht 50



```bash
python3 Main.py images/rat.jpg -w 50 -ht 25
```


Output image to a file
```bash
python3 Main.py images/rat.jpg -w 80 -o output.txt
```



Supports 

    JPEG: .jpg, .jpeg
    PNG: .png
    GIF: .gif
    BMP: .bmp
    TIFF: .tif, .tiff
    ICO: .ico
    WebP: .webp


```bash
                                 
                    `,^.`:l!<;,^'   .I, 
                   !-})}rcYCQLYzvt(]?[{; 
                  "+<+}}{ruYQQQ0QJvft?--` 
                 ir1_-)jrzvucccJZwQvnj?}(, 
               .-CZJf[}rcnuzLu/tjnzvrYYcYtl 
              .1QQCL0XcnrxuO#pCjf/(|fcpXYCx, 
              ]CLXcccXJYJJXzcrttt({[{|/vLQL/^ 
             +JLcrrnvYLCL0QLJCzt)]?[}}-)COLJ}`
            !XZQcjrvXYCQQOO0QJu(}]?{?]?+zO0Lc> 
           `tL00XnjncvcczXXXvf/|{[])()[]zLCXX{
           "rYYJYznxnvczzvuuuj({}]??][)uJCXvct'
           ,jXXYzcvnnvzXJJJYYzvf/|fnzYCQYYzuvn^
           .~ncccunuvcXJJXXYJ0mOqZZ00QO0JzvuvvI
            '?xrrjrzOZJvcvXQOdkhadmQLLLLCznxczI
              ~jrjt{)vQcvvut){(c0ZOQLLQQCcnuXX,
   ^l>+]{){]_!,l[/)<!!]ncu1__<]tuXCLQOZQYcvXJu'
 "+{jj|)fxuzQ0Qzxnx]!!i]cvurftuczCL0OOLJYXYJCt 
^[n/;.    .^!]rCwqQz|?{}cJLOOZZmpwmmO0QCYYCCC~
`-/[^          '!1uQZ0CQOZmpdppkkbkpmOLCLOZOt'
 ^_(]~!,^````^""`":~(Jdhao*#*o#MMMhZQC0mmLvj, 
   :~?}}}1)/nXzuvC0qdh#W8#abdpwmOLXXvYYvt-!I'
      .^":;l!!l!i+-{(/tjf}???-}{1?]1(/{?<!:,'
                              ..            
```



<a href='https://github.com/bigsk1/airats/blob/master/LICENSE'>LICENSE</a>

This project is licensed under MIT License.