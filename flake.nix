{
  description = "Byron's nix config based flakes";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Constants
    constants = import ./constants.nix;

    # 
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs constants.systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs constants.systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });
  in {
    inherit lib;

    nixosModules = import ./modules/nixos;
    darwinModules = import ./modules/darwin;

    overlays = import ./overlays { inherit inputs outputs; };
    packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
    formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

    # Nixos 
    # is there has a func: [attr] ==> { attr.x: attr; } ?
    nixosConfiguration = lib.genAttrs (
      map (host: host.hostname) constants.osGroupAttrs.nixos
    ) (hostname: lib.nixosSystem {
        modules = [ ./hosts/${hostname}/configuration.nix ];
        networking.hostName = ${hostname};
        specialArgs = {
          inherit inputs outputs; 
          host = constants.hostAttrs.${hostname};
        };
    });
  };
}
