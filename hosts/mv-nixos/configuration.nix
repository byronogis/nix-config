{
  config,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix

    ../__optional/systemd-boot.nix
    ../__optional/nix-ld.nix
    ../__optional/podman.nix
    ../__optional/hermes-agent.nix
  ];

  networking.firewall.enable = outputs.lib.mkForce false;

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024; # in megabytes
    }
  ];

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  # TODO cloudflared
  # services.cloudflared.enable = true;

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
