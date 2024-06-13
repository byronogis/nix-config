{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix

    ../__optional/systemd-boot.nix
    ../__optional/nix-ld.nix
    ../__optional/vsftpd.nix
    ../__optional/v2raya.nix
  ];

  networking.firewall.enable = lib.mkForce false;

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024; # in megabytes
    }
  ];

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
