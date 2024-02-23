---
---

# Nix binary cache

A sales-pitch for self-hosting Nix binary caches

---

# Nix binary cache

Why?
- Speed up builds
- Nice to have things locally available at build

---

# NixOS configuration

Use nix-serve!

```
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };
```

Note: you need a job or something to populate the cache.

See [nixos.wiki: Binary Cache](https://nixos.wiki/wiki/Binary_Cache) for more details

My config: [cache.nix](https://github.com/heywoodlh/nixos-configs/blob/f1a82697aa4d7a3f1552a934bbb0eba9c57307be/nixos/roles/nixos/cache.nix)

---

# MacOS configuration

Mountains to climb:
1. No Nix-Darwin module
2. No working examples that I could find
3. Nix-Serve is only available on Intel Macs

Thankfully, open source still wins:

[attic: multi-tenant Nix Binary cache (written in Rust)](https://github.com/zhaofengli/attic)

---

# The solution: run attic on MacOS with launchd

TL;DR

```
let
  ...
  runCache = pkgs.writeShellScript "serve-cache" ''
    ${atticServer}/bin/atticd --listen 0.0.0.0:8080 &>>/tmp/binary-cache.log
  '';
in {
  ...
  launchd.daemons.nix-cache = {
    command = "${runCache}";
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive = true;
  };
  ...
}
```

[NixOS Discourse: Nix Binary Cache for MacOS/Nix-Darwin with Attic](https://discourse.nixos.org/t/nix-binary-cache-for-macos-nix-darwin-with-attic/40118)

---

# The upsides of a Nix binary cache on MacOS

A Mac with Nix-Darwin and Rosetta2 can build any of the following:
  1. Linux builds (with Nix-Darwin's `linux-builder`)
  2. ARM64 and Intel builds because Rosetta2 is magic
  3. You can even pass Rosetta2 capabilities to a NixOS VM in UTM

The primary downsides:
  1. Launchd is terrible
  2. MacOS is a horrible platform to remotely manage

---
