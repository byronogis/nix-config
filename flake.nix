{
  description = "A nix config based flakes.";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    flake-utils.url = "github:numtide/flake-utils";


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
    };

    # sop
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

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
      inherit lib;

      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;

      overlays = import ./overlays { inherit inputs outputs; };
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
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
