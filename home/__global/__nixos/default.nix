{ outputs, user, lib, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  home = {
    homeDirectory = "/home/${user.username}";
  };
}
