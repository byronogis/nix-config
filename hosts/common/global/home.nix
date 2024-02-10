{inputs, outputs, host, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users = builtins.mapAttrs (
    name: value: (
      import ../../../home/${name} args {
        inherit inputs outputs host;
        user = value;
      }
    )
  ) host.userAttrs;
}
