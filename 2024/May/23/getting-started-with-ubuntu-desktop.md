---

# Getting started with Ubuntu Desktop

---

## What is Ubuntu?

User friendly Linux distribution by Canonical

Based on another Linux distrubition named Debian

---

## Ubuntu release cycle

Canonical releases long-term-support (LTS) releases every 2 years in April

Main releases are in April, interim releases are October

Ubuntu's versioning is `YEAR.MONTH`:
- 22.04: April 2022 LTS releases
- 23.10: October 2023 interim release

At the time of writing, the latest supported Ubuntu release is 24.04 (codename Noble) -- an LTS release

---

## Desktop environment

In Linux, you have many choices for desktop environments:
1. GNOME
2. KDE
3. XFCE
4. Hyprland
5. Others

The default on Ubuntu is GNOME

---

## Package management

Two primary package management tools are available out of the box for Ubuntu:
1. The `apt` package manager
2. Snap*

The Software Center app on Ubuntu makes it easy to install packages!

*Canonical's handling of Snap has made many Ubuntu users unhappy

---

## Package management (apt)

Here are some example commands for `apt`

Update the `apt` cache:

```
sudo apt update
```

Search for packages named `firefox`:

```
sudo apt-cache search firefox
```

---

Install Firefox:

```
sudo apt install firefox
```

Uninstall Firefox:

```
sudo apt remove firefox
```

---

## Package management (Snap)

Search for packages named `firefox`:

```
snap search firefox
```

Install Firefox:

```
snap install firefox
```

Remove Firefox

```
snap remove firefox
```

---

Or just use the Software Center provided by Ubuntu!

---

## Some notes on package management

There are a lot of packages not available by default via `apt`:
- Most Linux software provide installation instructions for Ubuntu
- You can use PPAs (personal package archives) to install missing software, too

Reasons people don't like snap:
- Canonical kind of forces you to use it on Ubuntu
- Lack of control for the end-user, lots of control for app developer
- Closed-source back end


---

## Software to check out:

Browsers:
- Firefox
- Chrome

Terminal emulators:
- GNOME terminal
- Terminator
- Kitty
- Alacritty

Text editors/development environments:
- Gedit
- VSCode
- Command line: Nano, Vim

---

Office suite:
- LibreOffice
