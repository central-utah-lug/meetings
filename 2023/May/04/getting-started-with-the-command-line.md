---
marp: true
title: Getting Started With The Command Line
description: Slide description
paginate: true
_paginate: false
---

# <!--fit--> Getting started with the command line!

#### \*My thoughts on using the command line\*


-------------------------------------------------

## What is the "command line"?

The command line is a text-based interface for interacting with your computer.

It is often referred to as a CLI or Command-line Interface.

Despite what most people think: you can do _all_ of your computing from the command line.

-------------------------------------------------

## Command-line specific terms:

* Shell: I consider this the "flavor" of command line you're using

* Terminal/terminal emulator: Graphical app for accessing your shell

* Script: A file containing multiple commands for automating tasks

-------------------------------------------------

## POSIX-compliant shells:

POSIX is a family of standards that many shells comply with.

Most of the shells on Unix-like systems (MacOS, Linux, FreeBSD) shells are POSIX-compliant.

Here are some well-known POSIX shells:

* `bash` (Bourne-Again Shell): default user shell on most Linux systems, an old version is installed by default on MacOS

* `zsh` (Z shell): default user shell on MacOS, often installed by default on Linux -- or available as a package to install

* `sh` (Bourne Shell): usually available on every Unix/Unix-like system

-------------------------------------------------

## Non-POSIX-compliant shells:

While less common on Unix-like operating systems, non-POSIX shells are widely used and available.

Some well-known non-POSIX shells available on Unix-like systems

* `pwsh` (PowerShell Core): Microsoft's (now) cross-platform, open source shell
  * > Note: PowerShell Core is a newer version of the same PowerShell on Windows
  * > The default PowerShell on Windows is an older, feature-complete version called "Windows PowerShell"

* `fish` (Fish Shell): A user-friendly, modern shell

-------------------------------------------------

## The Terminal

A terminal emulator is just a graphical app for accessing a virtual shell session.

* Terminal.app: default terminal app on MacOS

* GNOME Terminal: the default terminal app on most GNOME-based Linux distributions (Ubuntu, Fedora, etc.)

* Alacritty: cross-platform (Windows, MacOS, Linux, BSD), GPU accelerated terminal emulator 

* Kitty: cross-platform (MacOS, Linux), GPU accelerated terminal emulator

* iTerm: MacOS specific terminal emulator with tons of features

* VSCode: not technically a terminal emulator, but has one built in -- how many people use the command line

* Windows Terminal: Windows specific terminal with tons of features

-------------------------------------------------

## What can you do with the command line?

Everything! But let's go through some examples.

### Install apps with Homebrew (MacOS):

```
brew install --cask discord
```

### Install apps with pacman (Arch Linux):

```
sudo pacman -Sy discord
```

-------------------------------------------------
## What can you do with the command line (cont.)?

### Network troubleshooting

Check DNS: 

```
$ dig google.com +short
142.250.176.14
```

Ping:

```
$ ping google.com -c 1
PING google.com (142.250.176.14) 56(84) bytes of data.
64 bytes from lax17s51-in-f14.1e100.net (142.250.176.14): icmp_seq=1 ttl=116 time=43.5 ms
```

-------------------------------------------------
## What can you do with the command line (cont.)?

Messaging!

### Join the group chat group with SSH:

```
ssh chat.culug.group
```

### iMessage:

Made possible via `gomuks`, Matrix and Matrix's iMessage bridge

(Don't try this unless you like hurting yourself)

```
58083 (iMessage)         │14:11:28 +18035903357 (i ║ Hey! this is Max, from Distinct Pharma offering great deals on all medications.                                                          │                    
39858 (iMessage)         │                         ║ All quality products available on 3-4 days shipping.                                                                                     │                    
liberachat               │                         ╨ All types of Cards accepted.                                                                                                             │                   
```

-------------------------------------------------


## Where do I start?

Here are some tips I would recommend to get started:

* Pick a shell and learn how to do _everything_ from it (I recommend BASH)
  * Make it pretty, customize the prompt and color scheme

* Pick a terminal emulator and make it pretty and enjoyable to work from
  * The unixporn subreddit is a great place for inspiration: https://reddit.com/r/unixporn

* Spin up a Linux server, SSH into it and manage it strictly from the command line 

-------------------------------------------------

## A fun exercise for learning the command line on a Linux environment:

Run this Docker command to play with a tutorial environment:

```
docker run --rm -it docker.io/guye1296/linux-by-ctf
```
