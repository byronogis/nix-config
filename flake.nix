{
  description = "A nix config based flakes.";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Flake parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Persistence
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Disk Management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sop
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # devenv
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # KDE Plasma Manager (unofficial)
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    # Hermes Agent
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      ...
    }:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      settings = import ./settings.nix { inherit lib; };
      localLib = import ./lib { inherit lib; };

      # Build the ctx for a specific host
      mkCtx = host: {
        inherit settings;
        hosts = settings.hostAttrs;
        users = settings.userAttrs;
        inherit host;
        user = null; # Will be set in home-manager context
      };

      devenvRoot = builtins.toString ./.;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = settings.systems;

      perSystem =
        { pkgs, ... }:
        {
          packages = import ./pkgs { inherit pkgs; };
          devShells = import ./shell { inherit inputs pkgs devenvRoot; };
          formatter = pkgs.nixfmt-tree;
        };

      flake = {
        # Combined lib
        lib = nixpkgs.lib // {
          _hm = home-manager.lib.hm;
          _local = localLib;
        };

        # Overlays
        overlays = import ./overlays { inherit inputs; };

        # Reusable modules
        nixosModules = import ./modules/nixos;
        darwinModules = import ./modules/darwin;
        homeManagerModules = import ./modules/home-manager;

        # NixOS configurations
        nixosConfigurations = lib.genAttrs (map (host: host.hostname) (settings.osGroupAttrs.nixos or [ ])) (
          hostname:
          let
            host = settings.hostAttrs.${hostname};
          in
          lib.nixosSystem {
            modules = [
              ./hosts/__global
              ./hosts/__global/__nixos
              ./hosts/${hostname}/configuration.nix
            ];
            specialArgs = {
              inherit inputs outputs;
              ctx = mkCtx host;
            };
          }
        );

        # Darwin configurations
        darwinConfigurations = lib.genAttrs (map (host: host.hostname) (settings.osGroupAttrs.darwin or [ ])) (
          hostname:
          let
            host = settings.hostAttrs.${hostname};
          in
          inputs.nix-darwin.lib.darwinSystem {
            modules = [
              ./hosts/__global
              ./hosts/__global/__darwin
              ./hosts/${hostname}/configuration.nix
            ];
            specialArgs = {
              inherit inputs outputs;
              ctx = mkCtx host;
            };
          }
        );
      };
    };
}
