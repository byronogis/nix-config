# See https://nix-community.github.io/home-manager/nixos-options.xhtml
# See https://nix-community.github.io/home-manager/nix-darwin-options.xhtml
{ inputs
, outputs
, host
, pkgs
, localLib
, ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs localLib host; };
  home-manager.backupFileExtension = "backup";

  home-manager.users =
    builtins.mapAttrs
      (username: user: {
        _module.args = {
          inherit user;
        };

        imports = [
          ../../home/__global
          ../../home/${username}

          (
            let
              hostSpecialPath = ../../home/${username}/${host.hostname}.nix;
            in
            if (builtins.pathExists hostSpecialPath) then hostSpecialPath else { }
          )
        ];
      })
      host.userAttrs;
}
