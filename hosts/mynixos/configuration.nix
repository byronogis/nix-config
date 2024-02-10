{
  config,
  lib,
  pkgs,
  ... 
}: {
  imports = [
    ./hardware-configuration.nix
    
    ../common/global
  ];

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
