{ localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;
}
