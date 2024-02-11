# See https://nix-community.github.io/home-manager/nixos-options.xhtml
# See https://nix-community.github.io/home-manager/nix-darwin-options.xhtml

{inputs, outputs, host, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs host pkgs; };
  
  home-manager.users = builtins.mapAttrs ( name: value: (
    import ../../../home/${name} {
      inherit inputs outputs host pkgs;
      user = value;
    }
  )) host.userAttrs;
}
