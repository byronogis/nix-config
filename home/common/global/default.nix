{ user, lib, ... }: {
  imports = lib.attrsets.mapAttrsToList
    (name: _: (builtins.toString ./${name}))
    (lib.attrsets.filterAttrs
      (name: type: (type == "regular" && name != "default.nix"))
      (builtins.readDir (builtins.toString ./.)));

  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
    stateVersion = "23.11";
  };
  programs = {
    home-manager.enable = true;
  };
}
