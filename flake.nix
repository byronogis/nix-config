{
  description = "A nix config based flakes.";

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";


    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Persistence
    impermanence.url = "github:nix-community/impermanence";

    # Disk Management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-ld
    nix-ld-rs = {
      url = "github:/nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };

    # sop
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    # devenv
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };

    /**
     * mainly for other inputs to follow
     */
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
    systems.url = "github:nix-systems/default";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs =
    { self
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // inputs.home-manager.lib // inputs.flake-utils.lib;

      localLib = import ./lib { inherit lib; };
      settings = import ./settings.nix { inherit lib; };

      forEachSystem = f: lib.genAttrs settings.systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs settings.systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    {
      lib = lib // localLib;

      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;

      overlays = import ./overlays { inherit inputs outputs; };
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell { inherit inputs pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      # Nixos 
      # TODO is there has a simply way: [attr ...] ==> { attr.x: attr; ... } ?
      nixosConfigurations = lib.genAttrs
        (map (host: host.hostname) settings.osGroupAttrs.nixos)
        (hostname: lib.nixosSystem {
          modules = [
            ./hosts/__global
            ./hosts/${hostname}/configuration.nix
          ];
          specialArgs = {
            inherit inputs outputs localLib;
            host = settings.hostAttrs.${hostname};
          };
        });
    };
}
