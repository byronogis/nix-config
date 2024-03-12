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
                sshAuthorizedKeysFile = ../../../home/${username}/ssh-authorized-keys.pub;
              in
              if (builtins.pathExists sshAuthorizedKeysFile) then (builtins.readFile sshAuthorizedKeysFile) else ""
            )
          ];
        }
      )
      host.userAttrs;

  # necessary because of user.shell choose it
  programs.zsh.enable = true;
}
