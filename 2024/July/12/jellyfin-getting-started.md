---
marp: true
enableHtml: true
theme: uncover
class:
  - invert
style: |
    section, ul, ol, li {
      justify-content: flex-start;
      text-align: left;
      margin-left: 0px;
      font-size: 24px;
    }
    h1, h2, h3, h4, h5, h6 {
      text-align: center;
    }
---

# Getting Started with JellyFin 

by Alex Mickelson

---

## What is Jellyfin

Self-Hosted media streaming server

Similar to plex

Can host movies, tv shows, music, photos, etc.

---

## Comparing Install Methods

<https://jellyfin.org/docs/general/installation>

Linux, Windows, or MacOS

Bare Metal vs Container

---

## Docker Compose

```yml
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    user: 1000:1000
    network_mode: "host"
    volumes:
      - /data/jellyfin/config:/config
      - /data/jellyfin/cache:/cache
      - /data/media/music/tagged:/music
      - /data/media/movies:/movies
      - /data/media/tvshows:/tvshows
    restart: "unless-stopped"
    environment:
      - JELLYFIN_PublishedServerUrl=https://your-proxy-url-if-you-have-one
```

---

Why host networking?

---

```conf
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name jellyfin.alexmickelson.guru;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "0";
    add_header X-Content-Type-Options "nosniff";
    client_max_body_size 20M;
    location / {
        proxy_pass http://host.docker.internal:8096;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_buffering off;
    }
    location /socket {
        proxy_pass http://host.docker.internal:8096;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Forwarded-Host $http_host;
    }
}
```

<https://jellyfin.org/docs/general/networking/nginx>

---

## Subtitles

[Open Subtitles](https://www.opensubtitles.org/en/search/sublang-en)

---

## Apps

<https://jellyfin.org/downloads/> for list of official clients

[Finamp](https://github.com/jmshrv/finamp) for android music player (with offline download)

---

## Obtaining Content

Handbrake and MakeMKV are good solutions (handbrake is complicated, but completely free)
- Best is probably MakeMKV for the original rip, then handbrake to compress to smaller file type (go from 40GB -> 15GB)
- Smaller file sizes are easier to stream

[7Digital](https://us.7digital.com/) sells FLAC music files

---

## Additional Reading

- [Jeff Gearling Blog](https://www.jeffgeerling.com/blog/2022/why-i-use-jellyfin-my-home-media-library)
    - [Video on ripping Blu-Ray](https://www.youtube.com/watch?v=RZ8ijmy3qPo)
- [Automatic Ripping Machine](https://github.com/automatic-ripping-machine/automatic-ripping-machine/)
    - Most ripping tools use MakeMKV, which needs a license
    - can use "beta" keys that expire every two months
    - [Configuration Page for details on keys](https://github.com/automatic-ripping-machine/automatic-ripping-machine/wiki/Configuring-ARM)
- [MakeMKV CLI Reference](https://www.makemkv.com/developers/usage.txt)
  - `makemkvcon mkv disc:0 all <output directory>`