{ outputs, user, lib, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  home = {
    homeDirectory = "/Users/${user.username}";
  };
}
