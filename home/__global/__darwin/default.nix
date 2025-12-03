{ outputs, user, lib, localLib, ... }: {
  imports = [ ] ++ localLib.import ./. { };

  home = {
    homeDirectory = "/Users/${user.username}";
  };
}
