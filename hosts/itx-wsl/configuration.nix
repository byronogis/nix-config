{
  config,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    ../__optional/wsl.nix
    ../__optional/nix-ld.nix
    ../__optional/podman.nix
    ../__optional/hermes-agent.nix
  ];

  networking.firewall.enable = outputs.lib.mkForce false;

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
