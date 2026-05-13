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
        # 工作目录指向项目挂载根目录，下面按用户名区分项目空间。
        cwd = "/data/workspace/projects";
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
