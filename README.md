# nix-config

## Highlight

- [impermanence](https://github.com/nix-community/impermanence) with btrfs
- disk manage by [disko](https://github.com/nix-community/disko)
- home manage by [home-manager](https://github.com/nix-community/home-manager)
- manage user and host info by [setting](./constants.nix) file
- ...

## Usage

cd first.

### New User & Host


#### Add new user

Add new user inside userAttrs. And then add user nix file in `home/<username>/default.nix`.

```nix
# See https://nix-community.github.io/home-manager/options.xhtml

{inputs, outputs, host, user, pkgs, ... }: {
  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
  };
  home.stateVersion = "23.11";
}
```

#### Add new host

Add new host inside hostAttrs. And then add host nix files in `host/<hostname>/`.

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
# enable flakes in live
export NIX_CONFIG="experimental-features = nix-command flakes"

# maybe should run this first (such in installer) when git is not install
nix shell nixpkgs#git
# or just delete ./git
rm -rf .git

# optional if not partition and format manually
## **Be aware of data**
nix run github:nix-community/disko -- --mode disko --flake /absolute/path/to/flakes#<hostname>
# check label, 
lsblk -o name,fstype,label,mountpoints,parttypename,partlabel,size
# set manually if not exit or not same with hostname
btrfs filesystem label /dev/<part> <hostname>

# install 
nixos-install --flake .#<hostname> --show-trace
```

### Rebuild After

```bash
nixos-rebuild switch
```

## References

[Misterio77/nix-config: Personal nixos and home-manager configurations. (github.com)](https://github.com/Misterio77/nix-config)
