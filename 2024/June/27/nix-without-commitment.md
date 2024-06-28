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

# Nix Without Commitment
##### by Alex Mickelson

---

## other stuff

Flirc (IR USB dongle)

nixos on the server

sunshine on amd vs nvidia graphics (with moonlight client)

spoofing motherboard as vm

---

## Third Party Package Managers
##### or package managers that do not run the OS

- flatpak
- snap
- chocolaty
- homebrew
- pip/npm/cargo

---

Life with a third party package manager

- need to download/install it on your own
- need to regularly update packages
- need to make sure its configuration is up to date

---

## What is nix?

- a package manager and associated tools
  - programming language
  - nixos operating system
  - home manager
  - nix-shell
- <https://en.wikipedia.org/wiki/Nix_(package_manager)>
- <https://shopify.engineering/what-is-nix> (more technical)
- <https://github.com/nix-community/awesome-nix>

---

## What is Home Manager?

Tool built on nix to customize a single users environment.

| Does                                                                                       | Does Not                                                          |
| ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| install packages                                                                           | manage background daemons (like docker)                           |
| allow you to configure your shell                                                          | exclude you from using other configurations                       |
| allow you to simplify your user config files (like .bashrc, fish configs, k9s, lazydocker) | manage your groups / password (those are system repsonsibilities) |
| allow you to customize gnome (via dconf)                                                   | change your shell (system manages login shell)                    |

---

## Installing (follow along)

nix package manager first <https://nixos.org/download/>

then home manager <https://nix-community.github.io/home-manager>

--- 

`.config/home-manager/home.nix`

```nix
{ config, pkgs, ... }:
{
  home.username = "alexm";
  home.homeDirectory = "/home/alexm";
  home.stateVersion = "24.05"; # do not change
  home.packages = with pkgs; [
    openldap
    k9s
    jwt-cli
    thefuck
    fish
    kubectl
    lazydocker
  ];
  programs.fish = {
    enable = true;
    shellAliases = {
      dang="fuck";
    };
    shellInit = ''
function commit
  git add --all
  git commit -m "$argv"
  git push
end
# have ctrl+backspace delete previous word
bind \e\[3\;5~ kill-word
# have ctrl+delete delete following word
bind \b  backward-kill-word
export VISUAL=vim
export EDITOR="$VISUAL"
export DOTNET_WATCH_RESTART_ON_RUDE_EDIT=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
set -x LIBVIRT_DEFAULT_URI qemu:///system
thefuck --alias | source
   '';
  };
  home.file = {
    ".config/lazydocker/config.yml".text = ''
gui:
  returnImmediately: true
    '';
  };
  home.sessionVariables = {
    EDITOR = "vim";
  };
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      toggle-maximized=["<Super>m"];
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
```

---
## Commands to know

- `home-manager switch`
- `nix-channel --list`
- `nix-shell -p <program>`
- `home-manager generations`

