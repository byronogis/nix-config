{ host
, lib
, config
, pkgs
, ...
}: {
  users = {
    users =
      builtins.mapAttrs
        (
          username: user: {
            extraGroups = [ "wheel" ];
            # `hashedPassword` > `password` > `hashedPasswordFile` > `initialPassword` > `initialHashedPassword`
            initialPassword = user.initialPassword;
            hashedPasswordFile = lib.attrByPath [ "${username}-password" "path" ] null config.sops.secrets;
            # https://nixos.org/manual/nixos/stable/options#opt-users.users._name_.isNormalUser
            isNormalUser = true;
            openssh.authorizedKeys.keys = [
              (
                let
                  sshAuthorizedKeysFile = ../../home/${username}/ssh-authorized-keys.pub;
                in
                if (builtins.pathExists sshAuthorizedKeysFile) then (builtins.readFile sshAuthorizedKeysFile) else ""
              )
            ];
          }
        )
        host.userAttrs;

    defaultUserShell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  sops.secrets = lib.mapAttrs'
    (username: user: lib.nameValuePair
      "${username}-password"
      {
        neededForUsers = true;
      }
    )
    host.userAttrs;
}
