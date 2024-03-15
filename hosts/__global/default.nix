# This file (and the global directory) holds config that i use on all hosts
{ inputs
, outputs
, host
, lib
, ...
}: {
  imports = lib.attrsets.mapAttrsToList
    (name: _: (builtins.toString ./${name}))
    (
      lib.attrsets.filterAttrs
        (name: type: (
          type == "regular"
          && (lib.strings.hasSuffix ".nix" name)
          && name != "default.nix"
        ))
        (builtins.readDir (builtins.toString ./.))
    );

  networking.hostName = host.hostname;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  services.fstrim.enable = true;
}
