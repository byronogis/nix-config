{ user, lib, ... }: {
  imports = lib.attrsets.mapAttrsToList
    (name: _: (builtins.toString ./${name}))
    (lib.attrsets.filterAttrs
      (name: type: (type == "regular" && name != "default.nix"))
      (builtins.readDir (builtins.toString ./.)));

  home = {
    stateVersion = "23.11";
    shellAliases = {
      # nix
      check = "nix flake check --show-trace";
      build = "sudo nixos-rebuild switch --show-trace --flake "; # add path when using, example `build .`
      update = "nix flake update";
      history = "nix profile history --profile /nix/var/nix/profiles/system";
      clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than"; # add time when using, example `clear 7d`
      gc = "sudo nix store gc --debug";

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
