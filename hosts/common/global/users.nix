{ host, lib, pkgs, ... }: {
  users.users = builtins.mapAttrs (
    name: value: (
      lib.trivial.mergeAttrs
      {
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        shell = pkgs.zsh;
      }
      values
    )
  ) host.userAttrs;
}
