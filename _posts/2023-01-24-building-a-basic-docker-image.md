---
title: Docker build a simple image
date: 2023-01-23 12:00:00  -500
categories: [docker]
tags: [docker,docs,linux,windows]    # Tags should always be in lowercase
image:
  path: /assets/images/headers/docker.webp
---


## How to build a simple docker image in seconds

<br>

The first thing you need is [docker installed](https://docs.docker.com/engine/) 

<br>

### Creating the Dockerfile

To build a simple "Hello I did it!" Docker image, you will need to create a Dockerfile that defines the instructions for building the image. 

The Docker file needs to be just that a file named Dockerfile , all one word and capitol D, in linux it would be :

<br>

```shell
sudo touch Dockerfile
```
<br>

then edit the file 

```shell
sudo nano Dockerfile
```
<br>

Paste the contents in the file and save it. CTL+X then Enter

<br> 

```shell
FROM alpine
CMD ["echo", "Hello I did it!"]

```
<br>

This Dockerfile uses the alpine image as a base, and runs the command echo "Hello I did it!" when the container is started.

<br>

### Building the Image

<br>

Once you have created the Dockerfile, you can build the image using the docker build command. Here is an example command that you can use to build the image:

<br>

```shell
docker build -t my-hello-image .

```

<br>

This command tells Docker to build an image using the Dockerfile in the current directory (indicated by the . at the end) and tag the image with the name my-hello-image.

<br>

### Running the Image
<br>

Once the image is built, you can run it using the docker run command. Here is an example command that you can use to run the image:

<br>

```shell
docker run my-hello-image

```
<br>

This command tells Docker to run the my-hello-image image and output the message "Hello I did it!"

And that's it, you can now use the command docker run my-hello-image 
to run your newly created image and see the message:

<br>

```shell
 "Hello I did it!" 
 ```
 printed on the screen.

<br>

If you want to see your image just use

<br>

 ```shell
 sudo docker images
 ```
 <br>
 and you will be shown that your image was made

 <br>

```shell
 REPOSITORY             TAG       IMAGE ID       CREATED          SIZE
my-hello-image         latest    26cdf940f9e6   50 minutes ago   7.04MB
```

### To remove your image 

<br>

Just use the command rmi and --force , you can also remove the alpine image that was made when building the image the same way.

<br>

```shell
sudo docker rmi <IMAGE-ID> --force
```





