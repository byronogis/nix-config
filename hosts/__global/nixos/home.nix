# See https://nix-community.github.io/home-manager/nixos-options.xhtml
# See https://nix-community.github.io/home-manager/nix-darwin-options.xhtml
{ inputs
, outputs
, host
, pkgs
, localLib
, ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
}
