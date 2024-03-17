{ user, lib, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  home = {
    stateVersion = "23.11";
    shellAliases = {
      # nix
      CHECK = "nix flake check --show-trace --impure --flake NCP";
      BUILD = "sudo nixos-rebuild switch --show-trace --flake NCP";
      UPDATE = "nix flake update --flake NCP";
      HISTORY = "nix profile history --profile /nix/var/nix/profiles/system";
      CLEAN = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than"; # add time when using, example `clear 7d`
      GC = "sudo nix store gc --debug";
      DEV = "nix develop --impure NCP";

      # service
      STOP = "sudo systemctl stop";
      START = "sudo systemctl start";
      STATUS = "systemctl status";
    };
  };
  programs = {
    home-manager.enable = true;
  };
}
