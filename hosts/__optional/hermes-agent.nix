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
      terminal.cwd = "/home/hermes/project";
    };

    container = {
      enable = true;
      backend = "podman";
      hostUsers = [ "byron" ];
      extraVolumes = [
        "/home/byron/project:/home/hermes/project"
      ];
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "byron" ];
      commands = [
        {
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
