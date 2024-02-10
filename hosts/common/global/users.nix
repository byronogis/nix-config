{ host, lib, pkgs, ... }: {
  users.users = builtins.mapAttrs (
    name: value: {
      extraGroups = [ "wheel" ];
      initialPassword = value.initialPassword;
      isNormalUser = true;
      shell = pkgs.zsh;
    }
  ) host.userAttrs;
}
