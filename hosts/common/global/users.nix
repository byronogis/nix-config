{ host
, lib
, pkgs
, ...
}: {
  users.users =
    builtins.mapAttrs
      (
        name: value: {
          extraGroups = [ "wheel" ];
          initialPassword = value.initialPassword;
          # https://nixos.org/manual/nixos/stable/options#opt-users.users._name_.isNormalUser
          isNormalUser = true;
          shell = pkgs.zsh;
          openssh.authorizedKeys.keys = [
            (
              let
                authorizedKeysPath = ../../../home/${name}/authorizedKeys.pub;
              in
              if (builtins.pathExists authorizedKeysPath) then (builtins.readFile authorizedKeysPath) else ""
            )
          ];
        }
      )
      host.userAttrs;
}
