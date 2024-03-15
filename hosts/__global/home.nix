# See https://nix-community.github.io/home-manager/nixos-options.xhtml
# See https://nix-community.github.io/home-manager/nix-darwin-options.xhtml
{ inputs
, outputs
, host
, pkgs
, ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs host; };

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
