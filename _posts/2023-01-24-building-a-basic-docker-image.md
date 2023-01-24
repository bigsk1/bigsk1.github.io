---
title: Docker build a simple image
date: 2023-01-23 12:00:00  -500
categories: [docker]
tags: [docker,docs]    # Tags should always be in lowercase
---


## How to build a simple docker image in seconds

<br>

The first thing you need is [docker installed](https://docs.docker.com/engine/) 


Creating the Dockerfile

To build a simple "Hello I did it!" Docker image, you will need to create a Dockerfile that defines the instructions for building the image. Here is an example Dockerfile that you can use as a starting point:

<br> 

```code
FROM alpine
CMD ["echo", "Hello I did it!"]

```
<br>

This Dockerfile uses the alpine image as a base, and runs the command echo "Hello I did it!" when the container is started.
Building the Image

<br>

Once you have created the Dockerfile, you can build the image using the docker build command. Here is an example command that you can use to build the image:

<br>

```code
docker build -t my-hello-image .

```

<br>

This command tells Docker to build an image using the Dockerfile in the current directory (indicated by the . at the end) and tag the image with the name my-hello-image.
Running the Image

Once the image is built, you can run it using the docker run command. Here is an example command that you can use to run the image:

<br>

```code
docker run my-hello-image

```
<br>

This command tells Docker to run the my-hello-image image and output the message "Hello I did it!"

And that's it, you can now use the command docker run my-hello-image to run your newly created image and see the message "Hello I did it!" printed on the screen.