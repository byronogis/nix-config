{ outputs, user, lib, localLib, ... }: {
  imports = [ ] ++ localLib.import ./. { };

  home = {
    homeDirectory = "/home/${user.username}";
  };
}
