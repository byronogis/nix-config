# AGENTS.md

本仓库给 AI 编码代理的常驻说明。保持简短：只加入能避免重复错误或保护高风险流程的规则。

[English](./AGENTS.md) | 中文

## 工作模型

- 这是一个面向 NixOS 和 nix-darwin 的多用户、多主机 Nix flake。
- `settings.nix` 是用户、主机、系统、OS 分组、持久化标记、`primaryUser` 和每台主机启用用户的事实来源。
- `flake.nix` 从 `settings.nix` 构造 `ctx`；模块应使用 `ctx`，不要重新 import `settings.nix`。
- 主机模块使用 `ctx.host`。Home Manager 按 `ctx.host.userAttrs` 迭代用户时，每个用户模块会收到 `ctx.user`。
- 共享行为放在 `hosts/__global/` 或 `home/__global/`；可选行为放在 `hosts/__optional/` 或 `home/__optional/`；单机专属行为放在 `hosts/<hostname>/`。

## 编辑规则

- 新增用户时，先在 `settings.nix:userAttrs` 中添加，再添加 `home/<username>/`。
- 通过 `settings.nix:hostAttrs.<hostname>.userAttrs` 在主机上启用用户；不要假设全局用户都属于每台主机。
- 新增主机时，先在 `settings.nix:hostAttrs` 中添加，再添加 `hosts/<hostname>/configuration.nix`。
- 不要硬编码用户名、主机名、system、启用用户等动态仓库数据；代码中从 `ctx` 或 `settings.nix` 派生，文档中使用占位符。
- 能从 `ctx.host.userAttrs` 派生用户列表时，不要硬编码用户列表。
- 优先使用现有 `outputs.lib._local` helper，避免一次性逻辑。
- 模块保持声明式。只有真实的启动/激活期行为才添加 activation script。
- 可选服务和包保持 opt-in；若单个主机或用户能 import 可选模块，不要扩大到全局 import。

## 高风险区域

- 除非用户明确要求，不要读取、打印、解密、复制或重写 SOPS secrets。
- SOPS 文件包括 `hosts/secrets.yaml` 和 `hosts/<hostname>/secrets.yaml`。
- 当前 SOPS age key 路径来自启用用户的 `~/.ssh/id_ed25519` 和主机 key `/etc/ssh/ssh_host_ed25519_key`；impermanent 主机会用 `ctx.host.persistencePath` 作为主机 key 前缀。
- Disko、boot/initrd、btrfs subvolumes、filesystem labels、persistence roots 和 `hardware-configuration.nix` 都按高风险处理。说明验证步骤。
- 对 impermanent NixOS 主机，持久化状态根目录是 `ctx.host.persistencePath`；通过 `outputs.lib._local.setHostPersistence` 或现有 `environment.persistence` 模式添加路径。
- ephemeral btrfs rollback 使用 systemd initrd。systemd device unit name 中的 `-` 要转义为 `\x2d`。

## 主机操作

- `nixos-rebuild`、`darwin-rebuild`、`systemctl`、宿主机 `podman`、Disko、filesystem、boot/initrd 和磁盘命令都视为主机操作。
- 如果处于容器或远程代理 shell，除非明确可在目标主机执行，否则只提供给用户在目标主机运行的命令。
- 未经明确确认且没有清晰目标时，不要执行破坏性主机操作。

## 命令

解析改动过的 Nix 文件：

```sh
nix-instantiate --parse <path>
```

评估受影响的主机：

```sh
nix eval .#nixosConfigurations.<hostname>.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.<hostname>.config.system.build.toplevel.drvPath
```

适当时格式化 Nix：

```sh
nix fmt
```

完成前检查空白：

```sh
git diff --check
```

## 文档

- `README.md` 是英文；`README.zh-cn.md` 是中文。保持结构对齐。
- `AGENTS.md` 是英文；`AGENTS.zh-cn.md` 是中文。保持结构对齐。
- 语言导航中，当前语言保留为纯文本，只链接另一种语言。
- README 命令中，在支持时优先把 `--flake .#<hostname>` 放在末尾。
- 不要把 AGENTS.md 写成 README 的副本。可链接文档，或在信息可发现时直接检查仓库。

## Git

- 不要 revert 用户改动。
- 除非用户明确要求，不要运行 `git reset`、`git clean`、rebase、force push 或大范围 checkout 命令。
- 忽略无关的 dirty worktree 改动。如果用户改动碰到你需要编辑的文件，基于这些改动继续工作。
- 只有用户要求时才 commit；使用简洁的 conventional commit message。
