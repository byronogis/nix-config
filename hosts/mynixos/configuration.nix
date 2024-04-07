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

    ../__optional/vmware.nix
    ../__optional/font.nix
    ../__optional/pipware.nix
    ../__optional/greetd.nix
    ../__optional/desktop/hyprland
  ];

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
