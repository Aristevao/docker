# Getting started with Docker
----

## Summary
This project aims to upload a simple Java Spring application in a container containing only a "Hello World" available on local port 8080 and a Docker configuration file (Dockerfile).

## What is a container?
A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings.

# Step by step in Java
---
### Requirements
                
1. Install Docker Desktop from [download link](https://www.docker.com/products/docker-desktop/).  
2. Create account and login to [DockerHub](https://hub.docker.com/login). 

---
### Configuring Docker
Create Dockerfile in project root and insert code below:

	FROM maven:4.0.0-jdk-8 as build
	WORKDIR /build
	COPY .
	RUN mvn clean package -DskipTests

	FROM openjdk:8 as run
	WORKDIR /app
	COPY -- from=build ./build/target/*.jar ./application.jar
	EXPOSE 8080

	ENTRYPOINT java -jar
	
### Line by line
`FROM openjdk:<jdk-version>` Get the base image from DockerHub that will be used to build the image for this project. In this case, as we are using Java, we need the JDK. Container runs on Linux and has the minimum necessary to run the application, in this case, to run Java Springboot it is necessary to contain Java (JDK).

`WORKDIR /app` Creates a working folder called app, all commands will be executed inside that folder and not in the project directory.

`COPY -- from=build ./build/target/*.jar ./application.jar` Copies the .jar file to the working folder (/app) called application.jar.

`EXPOSE 8080` Base port the container will access.

`ENTRYPOINT java -jar` Command executed when starting the container. In this case, java -jar is the command to run the project through the .jar.

The first to fourth line commands are to automatically build the application and place it inside the Docker working folder.

---
### Generate application build (.JAR file in ./target folder)
`$ ./mvn clean package`

### Create Docker Image
`$ docker build -t springdocker/springdocker .`
`-t`: image tag, can contain any name.
`.` : folder where the dockerfile is, as the command is being executed in the root, just a dot.

### Show all images created on the computer
`$ docker images`

### Create container for Docker image
`$ run docker --name springdockercontainer -p 8081:8080 springdocker/springdocker`

`-p`: defines the port to be read (8080) and which to expose for reading (8081).

To test you can call the address localhost:8081.

**Note:** You can create more than one container per image, but the name and port cannot be repeated (springdockercontainer and 8081).

### See running containers
`$ docker ps`

You can also view and interact with the container through Docker Desktop.

### Start a container
`$ docker start <container_name> (springdockercontainer)`

### Stop a container
`$ docker stop <container_name> (springdockercontainer)`

### Upload image from Docker to DockerHub
` $ docker login`

`$ docker push <image_name> (springdocker/springdocker)`

---
### The docker image is now available online on DockerHub.

Run DockerHub container in Docker playground.
This created image can spawn a container on a test virtual machine provided by Docker: [Labs - paly with Docker](https://labs.play-with-docker.com/). 
1. Login -> Start
2. Add New Instance (Create New Virtual Machine Instance)
3. Run the command: `$ docker run --name mydockerimage -p 5000:8080 springdocker/springdocker`
4. This will run the container and make port 5000 available directly from the virtual machine port.
