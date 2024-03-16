# This file (and the global directory) holds config that i use on all hosts
{ inputs
, outputs
, host
, lib
, localLib
, ...
}: {
  imports = [] ++ localLib.importAllFromPath ./.;

  networking.hostName = host.hostname;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  services.fstrim.enable = true;
}
