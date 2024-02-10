{inputs, outputs, host, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users = builtins.mapAttrs ( name: value: (
    import ../../../home/${name} {
      inherit inputs outputs host pkgs;
      user = value;
    }
  )) host.userAttrs;
}
