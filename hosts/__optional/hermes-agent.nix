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
      Hermes 工作区规则：

      宿主机用户工作区：
      ${workspaceList}

      - 当前默认宿主用户是 ${primaryUsername}。
      - 默认项目工作区是 ${primaryWorkspace}。
      - 用户未明确指定路径或用户名时，在默认项目工作区下查找、创建、修改项目。
      - 新项目应创建在 ${primaryWorkspace}/<project-name>。
      - 用户明确指定某个宿主用户时，使用该用户对应的 /data/workspace/projects/<username> 工作区。
      - 不要默认读写其他用户目录，除非用户明确要求。
      - 如果用户给出相对路径，将它解释为相对于默认项目工作区。
      - 如果任务涉及已有项目，先在默认项目工作区下查找最匹配的项目目录，再进入该目录操作。
      - 执行命令前先确认当前目录；如果不在目标项目目录，先切换到目标项目目录。
      - 修改文件前先读取相关文件和现有风格；不要覆盖用户未要求修改的内容。
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
