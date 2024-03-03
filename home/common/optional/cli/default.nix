{ lib, ... }: {
  imports = lib.attrsets.mapAttrsToList
    (name: _: (builtins.toString ./${name}))
    (lib.attrsets.filterAttrs
      (name: type: (type == "regular" && name != "default.nix"))
      (builtins.readDir (builtins.toString ./.)));
}
