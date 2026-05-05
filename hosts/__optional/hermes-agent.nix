# See https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup#nixos-module
{ inputs
, outputs
, host
, pkgs
, localLib
, config
, ...
}:
let
  hermes-agent = {
    stateDir = "/var/lib/hermes";
  };
  persistence = localLib.setHostPersistence {
    inherit host;
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

    settings.model = {
      provider = "custom";
      default = "deepseek-v4-flash";
      base_url = "https://api.deepseek.com";
      api_key = "\${PLATFORM_DEEPSEEK_API_KEY}";
    };

    container = {
      backend = "podman";
    };
  };

  sops = {
    secrets = {
      hermes-agent-env = { };
    };
  };
}
