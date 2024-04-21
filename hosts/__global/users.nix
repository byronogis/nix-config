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
          username: user:
            let
              hashedPasswordFileValue = lib.attrByPath [ "${username}-password" "path" ] null config.sops.secrets;
            in
            {
              extraGroups = [ "wheel" ];
              # `hashedPassword` > `password` > `hashedPasswordFile` > `initialPassword` > `initialHashedPassword`
              initialPassword = lib.mkIf (hashedPasswordFileValue == null) user.initialPassword;
              hashedPasswordFile = hashedPasswordFileValue;
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
