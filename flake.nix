{
  description = "A nix config based flakes.";

  # nixConfig = {
  #   extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
  #   extra-substituters = "https://devenv.cachix.org";
  # };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

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
    impermanence.url = "github:nix-community/impermanence";

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

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs =
    { self
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // inputs.home-manager.lib;

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
      homeManagerModules = import ./modules/home-manager;

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
            ./hosts/__global/__nixos
            ./hosts/${hostname}/configuration.nix
          ];
          specialArgs = {
            inherit inputs outputs localLib;
            host = settings.hostAttrs.${hostname};
          };
        });

      # Darwin
      darwinConfigurations = lib.genAttrs
        (map (host: host.hostname) settings.osGroupAttrs.darwin)
        (hostname: inputs.nix-darwin.lib.darwinSystem {
          modules = [
            ./hosts/__global
            ./hosts/__global/__darwin
            ./hosts/${hostname}/configuration.nix
          ];
          specialArgs = {
            inherit inputs outputs localLib;
            host = settings.hostAttrs.${hostname};
          };
        });
    };
}
