# See https://nix-community.github.io/home-manager/nix-darwin-options.xhtml
# Note: home-manager is configured in hosts/__global/home.nix
# This file only adds Darwin-specific home modules to each user
{
  inputs,
  outputs,
  ctx,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  home-manager.users = builtins.mapAttrs (username: user: {
    imports = [
      ../../../home/__global/__darwin
    ];
  }) ctx.host.userAttrs;
}
