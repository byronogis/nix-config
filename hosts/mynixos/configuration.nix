{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix

    ../common/global
    ../common/optional/systemd-boot.nix
    ../common/optional/nix-ld.nix
    ../common/optional/sops.nix
  ];

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
