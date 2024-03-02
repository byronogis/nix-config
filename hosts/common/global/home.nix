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
      (name: value: {
        _module.args = {
          user = value;
        };

        imports = [
          ../../../home/${name}

          (
            let
              hostSpecialPath = ../../../home/${name}/${host.hostname}.nix;
            in
            if (builtins.pathExists hostSpecialPath) then hostSpecialPath else { }
          )
        ];
      })
      host.userAttrs;
}
