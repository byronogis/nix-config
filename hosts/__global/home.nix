# See https://nix-community.github.io/home-manager/nixos-options.xhtml
# See https://nix-community.github.io/home-manager/nix-darwin-options.xhtml
{
  inputs,
  outputs,
  ctx,
  pkgs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs; };
  home-manager.backupFileExtension = "backup";

  home-manager.users = builtins.mapAttrs (username: user: {
    _module.args = {
      ctx = ctx // {
        inherit user;
      };
    };

    imports = [
      ../../home/__global
      ../../home/${username}

      (
        let
          hostSpecialPath = ../../home/${username}/${ctx.host.hostname}.nix;
        in
        if (builtins.pathExists hostSpecialPath) then hostSpecialPath else { }
      )
    ];
  }) ctx.host.userAttrs;
}
