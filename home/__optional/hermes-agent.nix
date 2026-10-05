{
  config,
  inputs,
  osConfig,
  ...
}:
{
  imports = [
    inputs.hermes-agent.homeManagerModules.default
  ];

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    workingDirectory = "${config.home.homeDirectory}/projects";
    settings = {
      model = {
        provider = "deepseek";
        default = "deepseek-flash";
      };
    };
    # sops-nix is configured by the host, not Home Manager.
    environmentFiles = [ osConfig.sops.secrets."hermes-agent-env".path ];
  };
}
