---
---

# Introduction to Containers

---

# Linux Containers

Tiny virtual Linux systems:
- Share the kernel of the host system
- Isolated via Linux kernel features (cgroups, namespaces)

Some precursors before Linux had container features:
- Chroot
- BSD jails

---

# Container keywords

- Image: a packaged filesystem (usually containing an application) to run within a container

- Image registry: an online repository of images, like [Docker Hub](https://hub.docker.com/)

- OCI: Open Container Initiative -- a set of standards that define how containers should work

---

Some popular images on Docker Hub:
- Ubuntu: [https://hub.docker.com/_/ubuntu](https://hub.docker.com/_/ubuntu)
- Apache: [https://hub.docker.com/_/httpd](https://hub.docker.com/_/httpd)
- Wordpress: [https://hub.docker.com/_/wordpress](https://hub.docker.com/_/wordpress)
- Python: [https://hub.docker.com/_/python](https://hub.docker.com/_/python)

---

There are multiple reasons people like Linux containers:
1. Easy to deploy
2. Extremely lightweight
3. Cross-platform (Linux, Windows, MacOS)

For example, run this on a machine with Docker to run a web server:

```
docker run -it --rm -p 8080:80 docker.io/httpd
```

(Visit http://localhost:8080 in your browser)

---

# Windows Containers

When referring to "containers" most people are talking about Linux containers.

Microsoft eventually developed Windows containers:
- Uses Docker and Hyper-V
- Isolated via Windows kernel features
- Not cross-platform

Most applications use Linux containers because they can run on any operating system.

Interesting reading: [History of Containers and the Root of Docker](https://learn.microsoft.com/en-us/archive/msdn-magazine/2017/april/containers-bringing-docker-to-windows-developers-with-windows-server-containers#history-of-containers-and-the-root-of-docker)

---

# Some popular container runtimes

Docker*
Containerd*
Podman*
LXC

*These runtimes use OCI images (i.e. they could all use images from Docker Hub)

---

Containers are ephemeral (temporary) and isolated by default:
- Container's filesystem is destroyed when the container is removed
- The container's network is not accessible unless exposed

---

# Docker

Containers != Docker

- Most mainstream containerization technology
- Very user-friendly
- First company to prioritize cross-platform Linux containers on Windows, MacOS

---

# Docker Hub

Docker Hub is an online repository of ready-to-use container images

There are multiple alternatives to Docker Hub for getting images:
- [Quay](https://quay.io/)
- [GitHub Container Registry](https://ghcr.io)
- [Google Container Registry](https://cloud.google.com/container-registry)

Usually by default, most container tools will use Docker Hub to find images

---

# Container orchestration tooling

Docker, Podman, etc. usually runs smaller-scale/non-production deployments

For large-scale/multi-service container deployments, some solutions have emerged:
- Docker Compose
- Kubernetes

---

# Some Docker command examples

Pull the Ubuntu image from Docker Hub to your local machine:

```
docker pull docker.io/ubuntu
```

Run a shell in a temporary Ubuntu container (will destroy itself after `exit`):

```
docker run -it --rm docker.io/ubuntu
```

---

Run a web server on port 8080:

```
docker run -d --name my-apache -p 8080:80 docker.io/httpd

# Check that it's running
docker ps

# Remove the container
docker rm -f my-apache
```

---

Run a container with files you want to persist on your host machine:

```
docker run -it --rm -v /tmp/persistent:/data docker.io/ubuntu
```
