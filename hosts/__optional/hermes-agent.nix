# See https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup#nixos-module
{
  inputs,
  outputs,
  ctx,
  pkgs,
  config,
  ...
}:
let
  hostUsernames = builtins.attrNames ctx.host.userAttrs;
  primaryUsername = ctx.host.primaryUser or (builtins.head hostUsernames);
  primaryWorkspace = "/data/workspace/projects/${primaryUsername}";
  workspaceList = builtins.concatStringsSep "\n" (
    builtins.map (username: "- ${username}: /data/workspace/projects/${username}") hostUsernames
  );
  # 将每个宿主机用户的项目目录挂载进 Hermes 容器，容器内按用户名分组。
  projectVolumes = builtins.map (
    username: "/home/${username}/projects:/data/workspace/projects/${username}:rw"
  ) hostUsernames;
  hermes-agent = {
    stateDir = "/var/lib/hermes";
  };
  persistence = outputs.lib._local.setHostPersistence {
    inherit (ctx) host;
    settings = {
      directories = [
        hermes-agent.stateDir
      ];
    };
  };
in
{
  imports = [
    persistence
    inputs.hermes-agent.nixosModules.default
  ];

  # https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup#options-reference
  services.hermes-agent = hermes-agent // {
    enable = true;
    addToSystemPackages = true;
    environmentFiles = [ config.sops.secrets."hermes-agent-env".path ];
    environment = {
      HERMES_HOST_USER = primaryUsername;
      HERMES_HOST_WORKSPACE = primaryWorkspace;
    };
    documents."USER.md" = ''
      ## Hermes 工作区规则

      ### 运行模式

      - Hermes gateway 运行在 Podman 容器中。
      - `terminal.backend=local` 表示命令在该容器内执行，不是宿主机 shell。
      - 工具不能直接执行宿主机系统命令。涉及 `nixos-rebuild`、`systemctl`、宿主机 `podman`、磁盘、boot/initrd 时，只给出命令，让用户在宿主机执行。

      ### 工作区

      ${workspaceList}

      - 默认宿主用户：`${primaryUsername}`。
      - 默认项目工作区：`${primaryWorkspace}`。
      - 未指定路径或用户 -> 只在默认项目工作区操作。
      - 新项目 -> `${primaryWorkspace}/<project-name>`。
      - 明确指定宿主用户 -> 使用 `/data/workspace/projects/<username>`。
      - 除非用户明确要求，不要读写其他用户目录。
      - 相对路径按默认项目工作区解析。

      ### 项目上下文

      - 进入项目后，优先遵循项目内规则。
      - 优先级：`.hermes.md` / `HERMES.md` / `AGENTS.md` / `CLAUDE.md` / `.cursorrules`。
      - 修改前先读取相关文件。
      - 保持现有风格。
      - 不要覆盖无关用户改动。

      ### 安全边界

      - 除非用户明确要求，不要读取、打印、复制或解密 secrets、`.env`、密钥文件、token 文件。
      - 如果必须读取 secret，不要在回复中泄露 secret 值。
      - 除非用户明确要求且范围清楚，不要执行破坏性操作：删除、重置、强制覆盖、批量 `chmod/chown`、`git reset/clean/rebase`、force push。

      ### 记忆

      - 只保存稳定偏好、环境事实、可复用约定。
      - 不要保存临时任务细节或敏感信息。
    '';

    settings = {
      model = {
        provider = "deepseek";
        default = "deepseek-v4-flash";
      };
      # 显式启用完整工具集，避免默认工具集变化影响可用能力。
      toolsets = [ "all" ];
      terminal = {
        # Hermes gateway 已运行在容器内，因此 local backend 表示命令在该容器中执行。
        backend = "local";
        # 默认进入主用户项目空间；其他用户目录仍挂载在 /data/workspace/projects 下。
        cwd = primaryWorkspace;
        timeout = 180;
      };
      # 长会话自动压缩上下文，降低上下文过长导致失败的概率。
      compression = {
        enabled = true;
        threshold = 0.50;
      };
      # 压缩任务使用辅助模型策略，避免强制占用主对话模型。
      auxiliary.compression = {
        provider = "auto";
        # model = "";
      };
      # Hermes 是常驻服务，开启长期记忆和用户画像能跨会话保留偏好。
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };
      # 限制单次任务循环轮数，防止异常任务长时间空转。
      agent = {
        max_turns = 60;
        verbose = false;
      };
      # 提高单次文件读取上限，方便处理较大的代码文件。
      file_read_max_chars = 100000;
    };

    container = {
      # 使用 NixOS module 的容器模式，Hermes gateway 和 local terminal 都在容器中运行。
      enable = true;
      backend = "podman";
      # 固定基础镜像，避免上游默认值变化导致容器环境漂移。
      image = "ubuntu:24.04";
      # 为这些宿主机用户创建 ~/.hermes 桥接，并加入 hermes 组以共享状态。
      hostUsers = hostUsernames;
      extraVolumes = projectVolumes;
    };
  };

  security.sudo.extraRules = [
    {
      users = hostUsernames;
      commands = [
        {
          # host CLI 需要通过 sudo -n podman exec 进入 systemd/rootful 管理的容器。
          command = "/run/current-system/sw/bin/podman";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  sops = {
    secrets = {
      hermes-agent-env = { };
    };
  };
}
