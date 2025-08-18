### 1. what is docker?

- Docker is an open platform for developing, shipping, and running applications.
- Docker allows you to separate your application from infrastructure.
- Docker allows running an application inside a loosely isolated environment called containers.
- The isolation and security let you run multiple containers simultaneously on given host.

  #### Containers

  - containers are lightweight and contains everything you need to run an application.
  - The unit for distributing and testing your applications
  - when you are ready, deploy your application into your production environment as a container or an orchestrated service. This works the same whether your production environment is a local data center, a cloud provider, or a hybrid of the two.
  - allowing developers to work in standardized environments using local containers which provide your applications and services.
  - Containers are great for continuous integration and continuous delivery (CI/CD) workflows.

### Docker Architecture

Docker uses a client-server architecture. The Docker client (docker) talks to the Docker daemon (dockerd), which does the heavy lifting of building, running, and distributing your Docker containers. The Docker client and daemon can run on the same system, or you can connect a Docker client to a remote Docker daemon. The Docker client and daemon communicate using a REST API, over UNIX sockets or a network interface. Another Docker client is Docker Compose, that lets you work with applications consisting of a set of containers.

#### Docker engine vs Docker daemon

The Docker daemon (dockerd) is a fundamental component of the Docker Engine. The Docker Engine provides the complete ecosystem for containerization, while the Docker daemon is the background process that performs the actual work of managing Docker objects based on instructions received through the Docker Engine's API

![alt text](images/docker-architecture.png)

### Docker objects

When you use Docker, you are creating and using images, containers, networks, volumes, plugins, and other objects. This section is a brief overview of some of those objects.

#### Image

An image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization.

#### Container

A container is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI

=> Docker is written in the Go programming language.

## 1. Project Setup

#### Postgres database service

- Pull the official postgres Image from the docker registry

```sh
$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```

- Run the container

```sh
$ docker run --name insta-training-db -e POSTGRES_PASSWORD=insta-training -d postgres
```

- We can always configure the Mapping PORT. In case we do not specify it while creating the container. (no straightforward command of that matter)

we need to:

-> inspect running containers

```sh
 docker ps
```

-> stop the running container:

```sh
 docker stop <container_name_or_id>
```

-> remove the container

```sh
 docker rm <container_name_or_id>
```

-> recreate the container with specifying the mapping PORT

```sh
$ docker run --name insta-training-db -e POSTGRES_PASSWORD=insta-training -p 5432:5432 -d postgres
```

- Inspect the container mapped PORT

```sh
 docker port <container_name_or_id>
```
