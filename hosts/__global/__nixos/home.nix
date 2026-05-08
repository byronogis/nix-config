# See https://nix-community.github.io/home-manager/nixos-options.xhtml
# Note: home-manager is configured in hosts/__global/home.nix
# This file only adds NixOS-specific home modules to each user
{
  inputs,
  outputs,
  ctx,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.users = builtins.mapAttrs (username: user: {
    imports = [
      ../../../home/__global/__nixos
    ];
  }) ctx.host.userAttrs;
}
