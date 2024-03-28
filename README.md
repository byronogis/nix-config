# nix-config

A nix config based flakes.

- [nix-config](#nix-config)
  - [Highlight](#highlight)
  - [Structure](#structure)
  - [Usage](#usage)
    - [First Time Install](#first-time-install)
    - [Rebuild(Update) After](#rebuildupdate-after)
  - [Add New User and Host](#add-new-user-and-host)
    - [Add new user](#add-new-user)
    - [Add new host](#add-new-host)
  - [Settings](#settings)
    - [User](#user)
    - [Host](#host)
  - [References](#references)

## Highlight

- [impermanence](https://github.com/nix-community/impermanence) with btrfs
- disk manage by [disko](https://github.com/nix-community/disko)
- home manage by [home-manager](https://github.com/nix-community/home-manager)
- manage user and host info by [settings](./settings.nix) file
- can set different ability to different host for single user
- manage development environment by [devenv](https://github.com/cachix/devenv)
- ...

## Structure

```
├── home                               # home manage
│   ├── __global                       # global config for user
│   ├── __optional                     # optional config for user
│   └── *                              # user dir
│    ├── default.nix                   # user config
│    ├── pgp-public-key.asc            # public pgp key for gpg
│    ├── ssh-authorized-keys.pub       # ssh authorized keys
│    └── <hostname>.nix                # special host config for user
├── hosts                              # host manage
│   ├── __global                       # global config for host
│   ├── __optional                     # optional config for host
│   └── *                              # host dir
│    ├── configuration.nix             # host config
│    ├── hardware-configuration.nix    # generated by nixos-generate-config
│    ├── disko-config.nix              # disko config
│    ├── secrets.yaml                  # secrets for current host
│    ├── ssh_host_ed25519_key.pub
│    └── ssh_host_rsa_key.pub
│   └── secrets.yaml                   # secrets for all host
├── lib                                # some useful lib for nix
├── modules
│   ├── darwin
│   └── nixos
├── overlays
├── pkgs
└── shell                              # shell managed with devenv
```

## Usage

### First Time Install

1. Boot from nixos live cd

2. Clone this repo

2. CD to current repo dir

3. Enable flakes environment

```bash
# enable flakes in live
export NIX_CONFIG="experimental-features = nix-command flakes"

# enable flakes environment
nix develop
```

4. [Config new user and host](#add-new-user-and-host)

5. Manage disk and partition

By disko:

Need add disko config file in `host/<hostname>/` and import in `host/<hostname>/configuration.nix` file  before.
More disko config example, see [github:nix-community/disko/example](https://github.com/nix-community/disko/blob/master/example/)

```bash
## **Be aware of data**
disko --mode disko --flake /absolute/path/to/current/repo#<hostname>

# check label, 
lsblk -o name,fstype,label,mountpoints,parttypename,partlabel,size

# set manually if not exit or not same with hostname
btrfs filesystem label /dev/<part> <hostname>
```

By hand:

Just like a regular linux installation. Partition, format, and mount.

6. Generate `hardware-configuration.nix`

```bash
# if you manage disk by disko
nixos-generate-config --no-filesystems --root /mnt

# else by hand
nixos-generate-config --root /mnt
```

Then copy `hardware-configuration.nix` to `host/<hostname>/` dir. And import it in `host/<hostname>/configuration.nix` file.

7. Install

```bash
# install 
nixos-install --flake .#<hostname> --show-trace --no-root-passwd
```

8. Reboot

```bash
reboot
```

### Rebuild(Update) After

```bash
sudo nixos-rebuild switch --flake .#<hostname> --show-trace
```

## Add New User and Host

### Add new user

Add new [user](#user) inside [userAttrs](./settings.nix). And then add user nix file in `home/<username>/`.

1. `default.nix` is needed. Like this:

```nix
# See https://nix-community.github.io/home-manager/options.xhtml

{inputs, outputs, host, user, pkgs, ... }: {
  imports = [
    ../__optional/cli
  ];
}
```

2. `<hostname>.nix` is optional. Just create and config it if you want to set extra for target host.

### Add new host

Add new [host](#host) inside [hostAttrs](./settings.nix). And then add host nix files in `host/<hostname>/`.

1. `configuration.nix` is needed. 

Like this:

```nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../__optional/systemd-boot.nix
  ];

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
```

2. `hardware-configuration.nix` is needed. 

This is be generated by nix command when you install above. Just copy it to here.

3. `ssh_host_ed25519_key.pub` is optional.

4. `ssh_host_rsa_key.pub` is optional.

## Settings

### User

A attr inside `userAttrs` in [settings](./settings.nix) file. Key is username, value is a attrset.

| Key                 | Type   | Required | Description                                                   |
| ------------------- | ------ | -------- | ------------------------------------------------------------- |
| username            | string | true     | username                                                      |
| usernameAlternative | string | false    | alternative username                                          |
| usernameFull        | string | false    | full name                                                     |
| useremail           | string | false    | email                                                         |
| initialPassword     | string | true     | initial password                                              |
| persistence         | set    | false    | persistence config, reference the impermanence[^impermanence] |
| usernameKeyForGit   | string | false    | key for git. If not set, use `username`                       |

[^impermanence]: [impermanence](https://github.com/nix-community/impermanence?tab=readme-ov-file#home-manager)

### Host

A attr inside `hostAttrs` in [settings](./settings.nix) file. Key is hostname, value is a attrset.

| Key             | Type   | Required | Description                                                       |
| --------------- | ------ | -------- | ----------------------------------------------------------------- |
| hostname        | string | true     | hostname                                                          |
| os              | string | true     | os                                                                |
| system          | string | true     | system                                                            |
| device          | string | false    | device                                                            |
| impermanence    | bool   | false    | whether to use impermanence                                       |
| persistencePath | string | false    | used by impermanence, absolute path                               |
| userAttrs       | set    | true     | user config, reference the user[^user], also can inherit directly |
| allowedPorts    | list   | false    | used by firewall                                                  |

[^user]: [User](#user)


## References

[Misterio77/nix-config: Personal nixos and home-manager configurations. (github.com)](https://github.com/Misterio77/nix-config)
