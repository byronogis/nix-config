# This file (and the nixos directory) holds config that i use on all nixos hosts
{ inputs
, outputs
, host
, lib
, localLib
, ...
}: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  networking.computerName = host.hostname;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Enable TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = host.system;
}
