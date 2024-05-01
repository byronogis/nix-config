{ inputs
, lib
, pkgs
, config
, host
, ...
}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 3 generations
      options = "--delete-older-than +3";
    };
    settings = rec {
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = trusted-substituters;
      trusted-substituters = [
        "https://mirror.nju.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      trusted-users = [ "root" "@wheel" ];
      access-tokens = [ ] ++
        # TODO  current need --impure flag when using build
        lib.attrsets.mapAttrsToList
          (
            username: _: "github.com=${builtins.readFile (lib.attrByPath [ "${username}-github-access-token" "path" ] null config.sops.secrets)}"
          )
          host.userAttrs;
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };

  sops.secrets = lib.mapAttrs'
    (username: user: lib.nameValuePair
      "${username}-github-access-token"
      { }
    )
    host.userAttrs;
}
