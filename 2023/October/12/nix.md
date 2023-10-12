---
---

# Nix

---
<!-- footer: nix -->

Nix is a cross-platform (Linux, MacOS, WSL) package manager and functional programming language

It brings the following benefits:
- Reproducibility
- Many packages
- Portable development environments

---

Some key terms:
- nixpkgs: The primary GitHub repo defining all the packages available to Nix https://github.com/nixos/nixpkgs
- NixOS: a Linux distribution built around Nix -- Nix's release cycle is based around NixOS releases (`22.11`, `23.05`, `23.11`)
- Flakes: a currently experimental, widely used Nix feature that defines self-contained Nix configurations

---

## Install Nix

Official installer:

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Determinate Systems (my preference, it has Flakes enabled by default) installer:

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

All packages available through Nix are searchable here: https://search.nixos.org

---

## Use Nix (non-flakes)

Add the nixpkgs-unstable channel: 

```
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
```

Update your channels:

```
nix-channel --update
```

Install the `vim` package: 

```
nix-env --install vim
```

Start a new shell with a list of packages installed in the shell environment: 

```
nix-shell -p dnsutils curl vim
```

---

## Use Nix (flakes)

Install the `vim` package from `nixpkgs`: 

```
nix profile install nixpkgs#vim
```

Try out my fully configured Vim flake: 

```
nix run github:heywoodlh/flakes?dir=vim
```

---

<!-- footer: home-manager -->

# Home Manager

Everything in Unix is a file. Home-Manager provides a convenient way with Nix to configure all of your apps.

Configuration files for apps in Linux are often called "dotfiles" because they have a `.` at the beginning (which hides them). Home Manager manages your dotfiles in your home directory (hence the name "Home" Manager).

Some links:
- https://nix-community.github.io/home-manager
- https://github.com/nix-community/home-manager

---
<!-- footer: nixos -->

# NixOS

NixOS is a Linux distribution that is fully managed with `nix`.

Everything in NixOS is defined via `/etc/nixos/configuration.nix`:
- Instead of installing packages and configuring them, you describe their configuration
- Can be extended even further with Home Manager's NixOS module
- NixOS configurations can be flaked (making it easy to deploy self-contained virtual machines from a flake)

After your desired NixOS configuration is described in `configuration.nix`, you can apply it with the following command:

```
sudo nixos-rebuild switch
```

NixOS is another working example of Nix in action.

---

## NixOS compared to a "normal" Linux distribution

On Ubuntu, these are the official instructions to install Nextcloud -- a popular, self-hosted Google Drive alternative:

```
sudo apt update && sudo apt upgrade
sudo apt install apache2 mariadb-server libapache2-mod-php php-gd php-mysql \
php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip

sudo mysql

> CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
> GRANT ALL PRIVILEGES ON nextcloud.* TO 'username'@'localhost';
> FLUSH PRIVILEGES;
> quit;

tar -xjvf nextcloud-x.y.z.tar.bz2
unzip nextcloud-x.y.z.zip

sudo cp -r nextcloud /var/www
sudo chown -R www-data:www-data /var/www/nextcloud
```

---

## Nextcloud installation on NixOS

In contrast, the following snippet in `/etc/nixos/configuration.nix` installs Nextcloud and all other dependencies it needs:

```
{ pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.tld";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/path/to/admin-pass-file";
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
```

---
<!-- footer: nixos -->

# Nix-Darwin

Nix-Darwin provides all of the benefits of NixOS on MacOS.

If you want a Unix-like desktop workstation, MacOS is often your only choice in an enterprise.

For me, Nix-Darwin makes my Macs feel like a Linux machine.
