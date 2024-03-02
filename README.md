# nix-config

## Highlight

- [impermanence](https://github.com/nix-community/impermanence) with btrfs
- disk manage by [disko](https://github.com/nix-community/disko)
- home manage by [home-manager](https://github.com/nix-community/home-manager)
- manage user and host info by [settings](./settings.nix) file
- can set different ability to different host for single user
- ...

## Usage

**cd first.**

`cd path/to/current/repo`

### New User & Host


#### Add new user

Add new user inside [userAttrs](./settings.nix). And then add user nix file in `home/<username>/`.


`default.nix` is needed. Like this:

```nix
# See https://nix-community.github.io/home-manager/options.xhtml

{inputs, outputs, host, user, pkgs, ... }: {
  imports = [
    ../common/global
    ../common/optional/cli/zsh.nix
  ];
}
```

#### Add new host

Add new host inside [hostAttrs](./settings.nix). And then add host nix files in `host/<hostname>/`.

`configuration.nix` is needed. Like this:

```nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/optional/systemd-boot.nix
  ];

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
```


### First Time Install

```bash
# enable flakes environment
nix-shell

# optional if not partition and format manually
## **Be aware of data**
nix run github:nix-community/disko -- --mode disko --flake /absolute/path/to/current/repo#<hostname>
# check label, 
lsblk -o name,fstype,label,mountpoints,parttypename,partlabel,size
# set manually if not exit or not same with hostname
btrfs filesystem label /dev/<part> <hostname>

# install 
nixos-install --flake .#<hostname> --show-trace
```

### Rebuild After

```bash
sudo nixos-rebuild switch --flake .#<hostname> --show-trace
```

## References

[Misterio77/nix-config: Personal nixos and home-manager configurations. (github.com)](https://github.com/Misterio77/nix-config)
