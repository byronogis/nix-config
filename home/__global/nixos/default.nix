{ outputs, user, lib, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;
}
