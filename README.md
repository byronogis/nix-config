# nix-config

A multi-user and multi-host Nix configuration based on flakes.

English | [中文](./README.zh-cn.md)

- [nix-config](#nix-config)
  - [Highlight](#highlight)
  - [Agent Guidance](#agent-guidance)
  - [Structure](#structure)
  - [Usage](#usage)
    - [First Time Install](#first-time-install)
      - [nixos](#nixos)
      - [darwin](#darwin)
    - [Rebuild(Update) After](#rebuildupdate-after)
  - [Add New User and Host](#add-new-user-and-host)
    - [Add new user](#add-new-user)
    - [Add new host](#add-new-host)
  - [Settings](#settings)
    - [User](#user)
    - [Host](#host)
  - [TODO](#todo)
  - [References](#references)

## Highlight

- [nixos][nixos], [darwin][darwin], and [wsl2][wsl2] support
- multi-user and multi-host configuration from [settings][settings]
- [impermanence][impermanence] with btrfs
- disk management by [disko][disko]
- home management by [home-manager][home-manager]
- per-host user sets through `ctx.host.userAttrs`
- host-specific user config with `home/<username>/<hostname>.nix`
- development environment managed by [devenv][devenv]
- secrets managed by [sops][sops]
- ...

## Agent Guidance

AI coding agents should read [AGENTS.md](./AGENTS.md) before changing this repository.

## Structure

```text
├── home/                                  # home manager configuration
│   ├── __global/                          # global config for users
│   │   ├── __darwin/                      # darwin-specific user config
│   │   └── __nixos/                       # nixos-specific user config
│   ├── __optional/                        # optional user config
│   └── <username>/                        # user directory
│       ├── default.nix                    # main home manager configuration for user
│       ├── pgp-public-key.asc             # public pgp key for user
│       ├── ssh-authorized-keys.pub        # ssh authorized keys for user
│       └── <hostname>.nix                 # host-specific user config
├── hosts/                                 # host-specific configuration
│   ├── __global/                          # global config for hosts
│   │   ├── __darwin/                      # darwin-specific host config
│   │   └── __nixos/                       # nixos-specific host config
│   ├── __optional/                        # optional host config
│   ├── <hostname>/                        # host directory
│   │   ├── configuration.nix              # main os configuration for host
│   │   ├── disko-config.nix               # disko configuration for host (optional)
│   │   ├── hardware-configuration.nix     # hardware configuration for host
│   │   ├── secrets.yaml                   # secrets for host
│   │   ├── ssh_host_ed25519_key.pub       # ssh host ed25519 public key for host
│   │   └── ssh_host_rsa_key.pub           # ssh host rsa public key for host
│   └── secrets.yaml                       # shared secrets for hosts
├── lib/                                   # shared libraries and utilities
├── modules/
│   ├── darwin/
│   ├── home-manager/
│   └── nixos/
├── overlays/
├── pkgs/
├── shell/                                 # shell managed with devenv
├── .envrc                                 # env file for direnv
├── settings.nix                           # global settings for nix configuration
├── default.nix                            # default shell configuration
├── flake.nix                              # flake configuration
└── flake.lock
```

## Usage

### First Time Install

#### nixos

1. Boot from the NixOS live image.

2. Clone this repo.

3. Change to this repo directory.

4. [Configure the new user and host](#add-new-user-and-host).

5. Enable the flakes environment.

```bash
# enable flakes in live environment
export NIX_CONFIG="experimental-features = nix-command flakes"

# enter development shell
nix develop
```

6. Manage disk and partition.

   - By disko:

      Add a disko config file in `hosts/<hostname>/` and import it in `hosts/<hostname>/configuration.nix` before running disko.
      More disko config examples: [github:nix-community/disko/example](https://github.com/nix-community/disko/blob/master/example/)
      Run the disko command from a root shell or an equivalent sudo environment.

      ```bash
      ## Be aware: this can destroy data.
      nix run github:nix-community/disko -- --mode disko --flake /absolute/path/to/current/repo#<hostname>

      # check labels
      lsblk -o name,fstype,label,mountpoints,parttypename,partlabel,size

      # set manually if missing or different from hostname
      btrfs filesystem label /dev/<part> <hostname>
      ```

   - By hand:

      Use the regular NixOS installation flow: partition, format, and mount.

7. Generate `hardware-configuration.nix`.

```bash
# if disk/filesystems are managed by disko
nixos-generate-config --no-filesystems --root /mnt

# if disk/filesystems are managed by hand
nixos-generate-config --root /mnt
```

Then copy `hardware-configuration.nix` to `hosts/<hostname>/` and import it in `hosts/<hostname>/configuration.nix`.

8. Install.

```bash
nixos-install --show-trace --no-root-passwd --flake .#<hostname>
```

<details>
<summary><b>Optional: manage keys for sops</b></summary>

Use this when bootstrapping a host that needs to decrypt SOPS secrets.
This repo loads age keys from each enabled user's `~/.ssh/id_ed25519` and from the host SSH key at `/etc/ssh/ssh_host_ed25519_key`.
On impermanent NixOS hosts, the host key is expected under the persistence root, for example `/persist/etc/ssh/ssh_host_ed25519_key`.

> [Generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)

- Generate or restore the needed user and host SSH keys.
- Copy host keys to the target system after install and before first reboot, such as `/mnt/etc/ssh` or `/mnt/persist/etc/ssh`.
- Set private key permissions: `chmod 0600 /path/to/key`.
- If recipients changed, update `.sops.yaml` on an existing trusted system and run `sops updatekeys path/to/secrets.yaml`.
- Run `nixos-enter` if you need to chroot into the new system, then run `nixos-rebuild boot --show-trace --flake .#<hostname>`.

When decrypting with another age key file:

```bash
sudo SOPS_AGE_KEY_FILE=/run/secrets.d/age-keys.txt sops hosts/secrets.yaml
```

</details>

9. Reboot.

```bash
reboot
```

#### darwin

1. Install nix and homebrew.

> https://nixos.org/download/#nix-install-macos
>
> https://brew.sh/

```bash
sh <(curl -L https://nixos.org/nix/install)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Clone this repo.

3. Change to this repo directory.

4. [Configure the new user and host](#add-new-user-and-host).

5. Enable the flakes environment.

```bash
# enable flakes
export NIX_CONFIG="experimental-features = nix-command flakes"

# enter development shell
nix develop
```

6. Install.

```bash
nix run github:LnL7/nix-darwin -- switch --show-trace --flake .#<hostname>
```

### Rebuild(Update) After

```bash
# nixos
sudo nixos-rebuild switch --show-trace --flake .#<hostname>

# darwin
nix run nix-darwin -- switch --show-trace --flake .#<hostname>
```

Host-level commands such as `nixos-rebuild`, `darwin-rebuild`, `systemctl`, host `podman`, Disko, boot/initrd, or disk operations should be run on the target host.

## Add New User and Host

### Add new user

Add a new [user](#user) inside [userAttrs][settings]. Then add user nix files in `home/<username>/`.

`userAttrs` is the global user pool. A user only becomes active on a host after being included in that host's `hostAttrs.<hostname>.userAttrs`.

1. `home/<username>/default.nix` is needed. Example:

    ```nix
    # See https://nix-community.github.io/home-manager/options.xhtml

    {
      inputs,
      outputs,
      ctx,
      pkgs,
      ...
    }:
    {
      imports = [
        ../__optional/cli
      ];
    }
    ```

2. `home/<username>/<hostname>.nix` is optional. Create it when the user needs extra config on a target host.

3. Add the user to each target host's `userAttrs`, for example:

    ```nix
    userAttrs = {
      inherit (userAttrs) <username>;
    };
    ```

### Add new host

Add a new [host](#host) inside [hostAttrs][settings]. Then add host nix files in `hosts/<hostname>/`.

`flake.nix` groups hosts by `os`, then builds `nixosConfigurations` and `darwinConfigurations` from `hostAttrs`. Each host receives `ctx.host`, and Home Manager is generated for every user in `ctx.host.userAttrs`.

1. `hosts/<hostname>/configuration.nix` is needed.

    Example:

    ```nix
    {
      config,
      outputs,
      pkgs,
      ...
    }:
    {
      imports = [
        ./hardware-configuration.nix
        ../__optional/systemd-boot.nix
      ];

      # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
      system.stateVersion = "23.11"; # Did you read the comment?
    }
    ```

2. `hardware-configuration.nix` is needed for NixOS hosts.

    It is generated by `nixos-generate-config` during install. Copy it to `hosts/<hostname>/`.

3. `disko-config.nix` is optional.

4. `ssh_host_ed25519_key.pub` is optional.

5. `ssh_host_rsa_key.pub` is optional.

## Settings

### User

An attr inside `userAttrs` in the [settings][settings] file. The key is username, and the value is an attrset.

| Key                 | Type   | Required | Description                                                                |
| ------------------- | ------ | -------- | -------------------------------------------------------------------------- |
| username            | string | true     | username                                                                   |
| usernameAlternative | string | false    | alternative username                                                       |
| usernameFull        | string | false    | full name                                                                  |
| useremail           | string | false    | email                                                                      |
| initialPassword     | string | true     | initial password                                                           |
| persistence         | set    | false    | persistence config, reference the [impermanence][impermanence-persistence] |
| usernameKeyForGit   | string | false    | key for git. If not set, use `username`                                    |

### Host

An attr inside `hostAttrs` in the [settings][settings] file. The key is hostname, and the value is an attrset.

| Key               | Type   | Required | Description                                                         |
| ----------------- | ------ | -------- | ------------------------------------------------------------------- |
| hostname          | string | true     | hostname                                                            |
| os                | string | true     | os, such as `nixos` or `darwin`                                     |
| system            | string | true     | nix system, such as `aarch64-linux`                                 |
| device            | string | false    | disk device used by host-specific disk config                       |
| impermanence      | bool   | true     | whether to use impermanence                                         |
| persistencePath   | string | false    | used by impermanence, absolute path                                 |
| userAttrs         | set    | true     | user config, reference the [user](#user), also can inherit directly |
| primaryUser       | string | true     | primary user, also used by nix-darwin [transition mechanism]        |
| allowedPorts      | list   | false    | used by firewall                                                    |
| allowedPortRanges | list   | false    | used by firewall                                                    |

[transition mechanism]: https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.primaryUser

## TODO

- [x] manage sops with system-wide under darwin

## References

[Misterio77/nix-config: Personal nixos and home-manager configurations. (github.com)](https://github.com/Misterio77/nix-config)

[nixos]: https://nixos.org/
[darwin]: https://github.com/LnL7/nix-darwin
[wsl2]: https://github.com/nix-community/NixOS-WSL
[impermanence]: https://github.com/nix-community/impermanence
[impermanence-persistence]: https://github.com/nix-community/impermanence?tab=readme-ov-file#home-manager
[disko]: https://github.com/nix-community/disko
[home-manager]: https://github.com/nix-community/home-manager
[devenv]: https://github.com/cachix/devenv
[sops]: https://github.com/Mic92/sops-nix
[settings]: ./settings.nix
