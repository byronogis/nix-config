# nix-config

基于 flakes、面向多用户多主机的 Nix 配置。

[English](./README.md) | 中文

- [nix-config](#nix-config)
  - [亮点](#亮点)
  - [Agent 说明](#agent-说明)
  - [结构](#结构)
  - [使用](#使用)
    - [首次安装](#首次安装)
      - [nixos](#nixos)
      - [darwin](#darwin)
    - [后续重建/更新](#后续重建更新)
  - [新增用户和主机](#新增用户和主机)
    - [新增用户](#新增用户)
    - [新增主机](#新增主机)
  - [Settings](#settings)
    - [User](#user)
    - [Host](#host)
  - [TODO](#todo)
  - [参考](#参考)

## 亮点

- 支持 [nixos][nixos]、[darwin][darwin] 和 [wsl2][wsl2]
- 通过 [settings][settings] 管理多用户多主机配置
- 通过 btrfs 使用 [impermanence][impermanence]
- 通过 [disko][disko] 管理磁盘
- 通过 [home-manager][home-manager] 管理用户环境
- 通过 `ctx.host.userAttrs` 管理每台主机启用的用户集合
- 通过 `home/<username>/<hostname>.nix` 管理用户的主机专属配置
- 通过 [devenv][devenv] 管理开发环境
- 通过 [sops][sops] 管理 secrets
- ...

## Agent 说明

AI 编码代理在修改本仓库前应先阅读 [AGENTS.zh-cn.md](./AGENTS.zh-cn.md)。

## 结构

```text
├── home/                                  # home manager 配置
│   ├── __global/                          # 用户全局配置
│   │   ├── __darwin/                      # darwin 用户配置
│   │   └── __nixos/                       # nixos 用户配置
│   ├── __optional/                        # 用户可选配置
│   └── <username>/                        # 用户目录
│       ├── default.nix                    # 用户主 home manager 配置
│       ├── pgp-public-key.asc             # 用户 pgp 公钥
│       ├── ssh-authorized-keys.pub        # 用户 ssh authorized keys
│       └── <hostname>.nix                 # 用户在指定主机上的配置
├── hosts/                                 # 主机配置
│   ├── __global/                          # 主机全局配置
│   │   ├── __darwin/                      # darwin 主机配置
│   │   └── __nixos/                       # nixos 主机配置
│   ├── __optional/                        # 主机可选配置
│   ├── <hostname>/                        # 主机目录
│   │   ├── configuration.nix              # 主机系统主配置
│   │   ├── disko-config.nix               # 主机 disko 配置，可选
│   │   ├── hardware-configuration.nix     # 主机硬件配置
│   │   ├── secrets.yaml                   # 主机 secrets
│   │   ├── ssh_host_ed25519_key.pub       # 主机 ssh ed25519 公钥
│   │   └── ssh_host_rsa_key.pub           # 主机 ssh rsa 公钥
│   └── secrets.yaml                       # 共享 secrets
├── lib/                                   # 共享库和工具函数
├── modules/
│   ├── darwin/
│   ├── home-manager/
│   └── nixos/
├── overlays/
├── pkgs/
├── shell/                                 # devenv 管理的 shell
├── .envrc                                 # direnv 配置
├── settings.nix                           # 全局 Nix 配置元数据
├── default.nix                            # 默认 shell 配置
├── flake.nix                              # flake 配置
└── flake.lock
```

## 使用

### 首次安装

#### nixos

1. 从 NixOS live cd 启动。

2. 克隆仓库。

3. 进入仓库目录。

4. [配置新用户和主机](#新增用户和主机)。

5. 启用 flakes 环境。

```bash
# 在 live 环境中启用 flakes
export NIX_CONFIG="experimental-features = nix-command flakes"

# 进入开发环境
nix develop
```

6. 管理磁盘和分区。

   - 通过 disko：

      先在 `hosts/<hostname>/` 中添加 disko 配置文件，并在 `hosts/<hostname>/configuration.nix` 中 import。
      更多 disko 示例见 [github:nix-community/disko/example](https://github.com/nix-community/disko/blob/master/example/)。
      在 root shell 或等价的 sudo 环境中运行 disko 命令。

      ```bash
      ## 注意：这会影响磁盘数据。
      nix run github:nix-community/disko -- --mode disko --flake /absolute/path/to/current/repo#<hostname>

      # 检查 label
      lsblk -o name,fstype,label,mountpoints,parttypename,partlabel,size

      # 如果缺失或和 hostname 不一致，可手动设置
      btrfs filesystem label /dev/<part> <hostname>
      ```

   - 手动管理：

      按常规 NixOS 安装流程分区、格式化、挂载。

7. 生成 `hardware-configuration.nix`。

```bash
# 如果磁盘/文件系统由 disko 管理
nixos-generate-config --no-filesystems --root /mnt

# 如果磁盘/文件系统手动管理
nixos-generate-config --root /mnt
```

然后把 `hardware-configuration.nix` 复制到 `hosts/<hostname>/`，并在 `hosts/<hostname>/configuration.nix` 中 import。

8. 安装。

```bash
nixos-install --show-trace --no-root-passwd --flake .#<hostname>
```

<details>
<summary><b>可选：管理 sops keys</b></summary>

引导一台需要解密 SOPS secrets 的主机时使用这一段。
当前仓库会从每个启用用户的 `~/.ssh/id_ed25519` 和主机 SSH key `/etc/ssh/ssh_host_ed25519_key` 加载 age keys。
对 impermanent NixOS 主机来说，主机 key 应位于持久化根目录下，例如 `/persist/etc/ssh/ssh_host_ed25519_key`。

> [Generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)

- 生成或恢复需要的用户 SSH key 和主机 SSH key。
- 安装后、首次重启前，把主机 key 复制到目标系统，例如 `/mnt/etc/ssh` 或 `/mnt/persist/etc/ssh`。
- 设置私钥权限：`chmod 0600 /path/to/key`。
- 如果 recipients 有变化，在已有可信系统中更新 `.sops.yaml`，再运行 `sops updatekeys path/to/secrets.yaml`。
- 如需进入新系统，可运行 `nixos-enter`，然后执行 `nixos-rebuild boot --show-trace --flake .#<hostname>`。

使用其他 age key 文件解密时：

```bash
sudo SOPS_AGE_KEY_FILE=/run/secrets.d/age-keys.txt sops hosts/secrets.yaml
```

</details>

9. 重启。

```bash
reboot
```

#### darwin

1. 安装 nix 和 homebrew。

> https://nixos.org/download/#nix-install-macos
>
> https://brew.sh/

```bash
sh <(curl -L https://nixos.org/nix/install)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. 克隆仓库。

3. 进入仓库目录。

4. [配置新用户和主机](#新增用户和主机)。

5. 启用 flakes 环境。

```bash
# 启用 flakes
export NIX_CONFIG="experimental-features = nix-command flakes"

# 进入开发环境
nix develop
```

6. 安装。

```bash
nix run github:LnL7/nix-darwin -- switch --show-trace --flake .#<hostname>
```

### 后续重建/更新

```bash
# nixos
sudo nixos-rebuild switch --show-trace --flake .#<hostname>

# darwin
nix run nix-darwin -- switch --show-trace --flake .#<hostname>
```

`nixos-rebuild`、`darwin-rebuild`、`systemctl`、宿主机 `podman`、Disko、boot/initrd 或磁盘操作应在目标宿主机上执行。

## 新增用户和主机

### 新增用户

在 [settings][settings] 文件的 `userAttrs` 中新增 [user](#user)，然后在 `home/<username>/` 中添加用户 nix 文件。

`userAttrs` 是全局用户池。只有把用户加入某台主机的 `hostAttrs.<hostname>.userAttrs` 后，这个用户才会在该主机启用。

1. 需要 `home/<username>/default.nix`，示例：

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

2. `home/<username>/<hostname>.nix` 是可选的。用户需要目标主机额外配置时再创建。

3. 将用户加入目标主机的 `userAttrs`，例如：

    ```nix
    userAttrs = {
      inherit (userAttrs) <username>;
    };
    ```

### 新增主机

在 [settings][settings] 文件的 `hostAttrs` 中新增 [host](#host)，然后在 `hosts/<hostname>/` 中添加主机 nix 文件。

`flake.nix` 会按 `os` 对主机分组，再从 `hostAttrs` 生成 `nixosConfigurations` 和 `darwinConfigurations`。每台主机都会收到 `ctx.host`，Home Manager 会为 `ctx.host.userAttrs` 中的每个用户生成配置。

1. 需要 `hosts/<hostname>/configuration.nix`。

    示例：

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

2. NixOS 主机需要 `hardware-configuration.nix`。

    它由安装时的 `nixos-generate-config` 生成，复制到 `hosts/<hostname>/` 即可。

3. `disko-config.nix` 是可选的。

4. `ssh_host_ed25519_key.pub` 是可选的。

5. `ssh_host_rsa_key.pub` 是可选的。

## Settings

### User

[settings][settings] 文件中 `userAttrs` 里的一个 attr。key 是用户名，value 是 attrset。

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

[settings][settings] 文件中 `hostAttrs` 里的一个 attr。key 是主机名，value 是 attrset。

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

## 参考

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
