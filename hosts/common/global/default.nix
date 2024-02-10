# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, host, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./editor.nix
    ./home.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./optin-persistence.nix
    ./users.nix
    ./zsh.nix
  ];

  home-manager.extraSpecialArgs = { inherit inputs outputs host; };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  services.fstrim.enable = true;
}
