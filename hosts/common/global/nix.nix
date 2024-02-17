{ inputs, lib, pkgs, ... }: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 3 generations
      options = "--delete-older-than +3";
    };
    settings = {
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://mirror.nju.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
      ];
      trusted-users = [ "root" "@wheel" ];
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };
}
