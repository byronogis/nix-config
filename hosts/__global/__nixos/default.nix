# This file (and the nixos directory) holds config that i use on all nixos hosts
{ inputs
, outputs
, host
, lib
, localLib
, ...
}: {
  imports = [ ] ++ localLib.importAllFromPath ./.;
}
