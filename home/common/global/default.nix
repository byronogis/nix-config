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
    shellAliases = {
      # nix
      check = "nix flake check --show-trace";
      update = "sudo nixos-rebuild switch --show-trace --flake ";

      # service
      stop = "sudo systemctl stop";
      start = "sudo systemctl start";
      status = "systemctl status";
    };
  };
  programs = {
    home-manager.enable = true;
  };
}
