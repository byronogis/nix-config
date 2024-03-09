{ host
, lib
, pkgs
, ...
}: {
  users.users =
    builtins.mapAttrs
      (
        username: user: {
          extraGroups = [ "wheel" ];
          initialPassword = user.initialPassword;
          # https://nixos.org/manual/nixos/stable/options#opt-users.users._name_.isNormalUser
          isNormalUser = true;
          shell = pkgs.zsh;
          openssh.authorizedKeys.keys = [
            (
              let
                authorizedKeysPath = ../../../home/${username}/authorizedKeys.pub;
              in
              if (builtins.pathExists authorizedKeysPath) then (builtins.readFile authorizedKeysPath) else ""
            )
          ];
        }
      )
      host.userAttrs;

  # necessary because of user.shell choose it
  programs.zsh.enable = true;
}
