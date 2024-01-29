---
marp: true
enableHtml: true
theme: uncover
class:
  - invert
style: |
    section {
      justify-content: flex-start;
      text-align: left;
    }
    h1, h2, h3, h4, h5, h6 {
      text-align: center;
    }
---
<style>
:root {
  font-size: 35px;
}
</style>

## First Day Kubernetes

By: Alex Mickelson

---


## Is kubernetes the natural progression to docker?

Loosely quoting Techno Tim from the state of the ChangeLog & Friends podcast <https://changelog.com/friends/27>
<br>
Many people think that it is, but kubernetes is really its own solution


--- 

## What is Docker

- packaging and runtime to server processes
- no gui
- includes dependencies
- very common runtime
- docker compose for grouping correlated services

---

Docker Compose

```yml
services:
  nextcloud:
    build:
      context: nextcloud
    container_name: nextcloud
    environment:
      - TZ=America/Denver
      - OVERWRITEPROTOCOL=https
      - MYSQL_PASSWORD=redacted
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=nextcloud-db
    volumes:
      - /data/nextcloud/html:/var/www/html
      - /data/media/music:/music
    restart: unless-stopped
    
  nextcloud-cron:
    build:
      context: nextcloud
    container_name: nextcloud-cron
    environment:
      - TZ=America/Denver
      - OVERWRITEPROTOCOL=https
      - MYSQL_PASSWORD=redacted
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=nextcloud-db
    volumes:
      - /data/nextcloud/html:/var/www/html
      - /data/media/music:/music
    restart: unless-stopped
    entrypoint: /cron.sh
    depends_on:
      - nextcloud

  nextcloud-db:
    image: mariadb:10.6
    container_name: nextcloud_db
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
    volumes:
      - /data/nextcloud-db/:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=redacted
      - MYSQL_PASSWORD=redacted
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
```


---

## Docker and docker compose can handle both building an app and running an app

---

## What is kubernetes?

- kubernetes is the defacto solution to the problem that I have too many docker containers for a single server 
    - like 50+ for a decent server
- an "open source"-d version of an internal google's Borg project. (borg pre-dates docker)
- collection of interfaces and protocols that can be implemented by any project
    - kubernetes "distributions" are different implementations of the common protocol
    - even the docker runtime is just an implementation of the "run a thing" interface


---

## Running local kubernetes

use microk8s
- lightweight runtime
- preconfigured with sensible defaults (default configurations not required by kubernetes interfaces)
- easy to install
- cannonical project, so it runs especially well on ubuntu
    - <https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s>

---

## Working With Kubernetes

Resource Types:

1. `Pod` is a docker container*
2. The thing that restarts pods after they crash are `Deployments`
3. The way you access pods within the cluster is using `Service`'s (they work like network proxies)
4. The way you access `Service`s from outside the cluster are `Ingress`'s


*This is a high-level description, there is a lot more going on here

---

## Examples - Deployment

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jellyfin-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jellyfin
  template:
    metadata:
      labels:
        app: jellyfin
    spec:
      containers:
        - name: jellyfin
          image: jellyfin/jellyfin:latest
          ports:
            - containerPort: 8096
```
---

## Examples - Service

```yml
apiVersion: v1
kind: Service
metadata:
  name: jellyfin-service
spec:
  selector:
    app: jellyfin
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8096
```
---

## Examples - Ingress

```yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jellyfin-ingress
spec:
  rules:
    - host: yourUrlToHit.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: jellyfin-service
                port:
                  number: 80
```

---

## Controllers

Enabling resources in kubernetes requires `Controllers` to be installed. 

There is an `Ingress Controller` (commonly an nginx reverse proxy)

There is a `Storage Controller` which can allocate nfs shares, cloud S3 buckets, etc


---

## Management Tools

`kubectl` is the command line utility, it is pretty good

`k9s` is a TUI for navigating the cluster, its the best