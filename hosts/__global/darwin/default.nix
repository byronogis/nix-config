# This file (and the nixos directory) holds config that i use on all nixos hosts
{ inputs
, outputs
, host
, lib
, localLib
, ...
}: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = host.system;
}
