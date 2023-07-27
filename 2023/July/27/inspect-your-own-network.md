%title: Inspecting your own Network
%author: heywoodlh

-> ## Inspecting your own Network <-

-> Open source network tools for inspecting your network <-

-> (This presentation was written with Vim, because I'm better than you) <-

---

-> ## Why inspect your network? <-

- Administration/Inventory (know what's on your network)
- Security (know what's _vulnerable_ on your network)
- It's interesting to see what devices exist and what they are talking to

---

-> ## Starting simple with nmap <-

You can use `nmap` to scan your network.

This command will ping hosts within a targeted IP range:

```
nmap -sn 192.168.50.0/24
```

If any hosts respond, it will return something like this:

```
❯ nmap -sn 192.168.50.0/24
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-27 13:05 MDT
Nmap scan report for 192.168.50.1
Host is up (0.0021s latency).
Nmap scan report for 192.168.50.77
Host is up (0.029s latency).
Nmap scan report for 192.168.50.103
Host is up (0.0045s latency).
```

---

-> ## Identify network-available services with nmap <-

Use the following command to get `nmap`'s the amount of information with a default `nmap` scan on an IP range:

```
nmap 192.168.50.0/24 --open
```

It should return something like this:

```
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-27 15:54 MDT
Nmap scan report for 192.168.50.1
Host is up (0.0056s latency).
Not shown: 792 filtered tcp ports (no-response), 204 closed tcp ports (conn-refused)
PORT    STATE SERVICE
22/tcp  open  ssh
53/tcp  open  domain
80/tcp  open  http
443/tcp open  https
```

---

-> DO A DEMO <-

`nmap` something

---

-> ## Visual vulnerability scans with Cloudflare's flan scanner <-

Cloudflare provides an open source vulnerability scanner named flan: https://github.com/cloudflare/flan

Flan is a wrapper around `nmap` that uses `nmap`'s Vulners plugin to identify versions of applications with known vulnerabilities.

I have a Docker container that can even run on something as lightweight as a Raspberry Pi: https://hub.docker.com/r/heywoodlh/flan-scan

---

-> ## Vulnerability scans with flan (pt. 2) <-

Here's a quick example of how to use the Docker container.

First, create a file named `flan-ips.txt` containing the IP ranges you want to scan:

```
echo 192.168.50.0/24 > flan-ips.txt
```

Next, create directories called `reports` and `xml_files` that we will place the scans into:

```
mkdir -p reports xml_files
```

Now, run the container:

```
docker run -it --rm \ 
   --network=host \ 
   -v $(pwd)/flan-ips.txt:/shared/ips.txt \ 
   -v $(pwd)/reports:/shared/reports \ 
   -v $(pwd)/xml_files:/shared/xml_files \ 
   -e format=html \ 
   heywoodlh/flan-scan
```

You can view the completed reports in the `reports` directory.

An example can be viewed here: https://github.com/central-utah-lug/meetings/blob/main/2023/July/27/reports/example-report.html

---

-> ## Netflow <-

Netflow is a lightweight way to collect metadata about network traffic in your network. Routers and firewalls often have built-in support for exporting netflow for connected devices.

We'll use two extremely lightweight tools for collecting and analyzing Netflow:
- Nfcapd: server for ingesting and storing Netflow data locally
- Nfdump: client for analyzing Netflow data

You can use a Docker image that I run for running an Nfcapd instance: https://hub.docker.com/r/heywoodlh/nfcapd

You can use the following commands to setup an Nfcapd instance:

```
sudo mkdir -p /flows
sudo chown -R 1000 /flows
docker run -d --name=nfcapd \
    --restart=unless-stopped \
    -p 9995:9995/udp \
    -v /flows:/flows \
    heywoodlh/nfcapd:latest
```

Then, on your router/firewall/whatever is exporting Netflow, point to the IP address of the server running the nfcapd container and use UDP port 9995.

---

-> ## Analyzing Netflow with nfdump <-

On your machine with nfcapd running, install the relevant package containing `nfdump`.

On Ubuntu:

```
sudo apt-get update
sudo apt-get install -y nfdump
```

Once `nfdump` is installed, you can use it to analyze collected netflow data and query it. For example, if I wanted to find all collected Netflow of sessions with destination port 80, I would use this command:

```
nfdump -R /flows/ dst port 80
```

Or, if you don't want to install `nfdump`, you can use my `nfdump` container to analyze the netflow data:

```
docker run -it --rm -v /flows:/flows heywoodlh/nfdump -R /flows/2023 "dst port 80"
```

---

-> DO A DEMO <-

Check out nfcapd/nfdump on my home network

I.E. Discord traffic (on `nix-nvidia.tailscale`):

```
nfdump -R /opt/nfcapd/flows "host 162.159.128.233"
```

---

-> ## Use the built-in tools for your networking equipment <-

Many routers and firewalls have built-in tooling for monitoring your network. I would highly recommend exploring the features available out-of-the-box with the networking hardware you have.

If you don't have a router or firewall with a flexible featureset, I would recommend one of three things:

1. Purchase better hardware with better features
2. Look into an open source operating system for your router (if your hardware is compatible)
3. Setup a network monitoring appliance to supplement your weak-sauce network

I recommend the following open source operating systems for networking equipment:
1. OPNSense or PFSense (firewalls, both BSD-based OS-es)
2. OpenWRT or DD-WRT (for routers, both Linux-based OS-es)

A network monitoring appliance can also be setup to tap into your network and monitor it.
