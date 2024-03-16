{ lib, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;
}
