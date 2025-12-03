{ outputs, user, lib, localLib, ... }: {
  imports = [ ] ++
    localLib.import ./. { } ++
    (builtins.attrValues outputs.homeManagerModules);

  home = {
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
  };
}
