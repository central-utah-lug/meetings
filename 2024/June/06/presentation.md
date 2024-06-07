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
    }
    h1, h2, h3, h4, h5, h6 {
      text-align: center;
    }
---

# Misc Stuff

---

## Gnome Quality of Life

Customize the "Activities Menu" search

<https://itsfoss.com/gnome-search/>

Be sure to order your applications in the search.

---

# llama3

Meta's "open source"-ish LLM


Run it with Ollama:
- ollama runs many LLM's
- is easy to use 
- cli and api (matches openai api?)

[NetworkChuck video](https://www.youtube.com/watch?v=Wjrdr0NU4Sk)

---

ollama docker compose

```yml
services:
  ollama:
    volumes:
      - ./data/ollama:/root/.ollama
    container_name: ollama
    tty: true
    ports:
      - 11434:11434
    restart: unless-stopped
    deploy:
      resources:
        reservations:
          devices:
              - driver: nvidia
                count: 1
                #device_ids: ['0']
                capabilities: [gpu]
    image: ollama/ollama

  open-webui:
    image: ghcr.io/open-webui/open-webui
    container_name: open-webui
    volumes:
      - ./data/open-webui:/app/backend/data
    depends_on:
      - ollama
    ports:
      - 0.0.0.0:8080:8080
    environment:
      - 'OLLAMA_BASE_URL=http://ollama:11434'
      - 'WEBUI_SECRET_KEY='
    restart: unless-stopped
```

---

## Getting the LLM

- Ollama hosts a mirror of all the major self-hosted LLM's.
- Can dowload from their repo through the settings interface.
- With a gpu I can sometimes get near chatgpt-speeds.

---

## Tailscale without installing it on host

I needed to run tailscale without conflicting with the work VPN.

Tailscale messed with IPtables in a way that broke the work VPN.

You can run tailscale in a docker container and have it host a SOCKS5 proxy, then configure firefox to proxy all traffic through the container. Now I have a "tailscale" browser that can access my homelab.

---

```yml
services:
  tailscale-outbound:
    build: .
    hostname: tailscale-outbound
    env_file:
      - .env
    environment:
      - TS_STATE_DIR=/var/lib/tailscale
      - TS_USERSPACE=false
      - TS_OUTBOUND_HTTP_PROXY_LISTEN=:1055
      - TS_SOCKS5_SERVER=:1055
    volumes:
      - tailscale-data:/var/lib/tailscale
    restart: unless-stopped
    ports:
    - 1055:1055
volumes:
  tailscale-data:
```

.env has a `TS_AUTHKEY=...` for authentication

---

## Tailscale for vpn only access as a sidecar container

I had a lot of issues running a dns server in a container. It kept coliding with the host's `resolvd` daemon / ports.

<https://tailscale.com/blog/docker-tailscale-guide> 
- has copy of `ts-serve-config.json`
- `docker-compose` next slide

---

```yml
services:
  ts-ingress:
    image: tailscale/tailscale:latest
    container_name: dns-tailscale
    hostname: home-dns
    restart: unless-stopped
    environment:
      - TS_STATE_DIR=/var/lib/tailscale
      - TS_SERVE_CONFIG=/config/config.json
    volumes:
      - tailscale-data:/var/lib/tailscale
      - ./ts-serve-config.json:/config/config.json
      - /dev/net/tun:/dev/net/tun
    cap_add:
    - net_admin
    - sys_module

  adguardhome:
    image: adguard/adguardhome
    container_name: dns-adguardhome
    network_mode: service:ts-ingress
    restart: unless-stopped
    volumes:
      - /data/adguard/conf:/opt/adguardhome/conf
      - /data/adguard/work:/opt/adguardhome/work
    depends_on:
      - ts-ingress

volumes:
  tailscale-data:
```

---

## Netbird - like tailscale, but can be completely self-hosted

Has a similar free tier

<https://github.com/netbirdio/netbird>

Documentation mentions connection logging, which would be great for audits / enterprise.

<https://docs.netbird.io/how-to/monitor-system-and-network-activity>


---

talk about homeassistant widget