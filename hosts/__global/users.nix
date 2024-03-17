{ host
, lib
, config
, pkgs
, ...
}: {
  users.users =
    builtins.mapAttrs
      (
        username: user: {
          extraGroups = [ "wheel" ];
          # `hashedPassword` > `password` > `hashedPasswordFile` > `initialPassword` > `initialHashedPassword`
          initialPassword =
            if (user ? "initialPassword")
            then user.initialPassword
            else null;
          hashedPasswordFile =
            if (user ? "initialPassword")
            then null
            else config.sops.secrets."${username}-password".path;
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

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  sops.secrets = lib.mapAttrs'
    (username: user: lib.nameValuePair
      "${username}-password"
      {
        neededForUsers = true;
      }
    )
    (lib.attrsets.filterAttrs
      (username: user: !(user ? "initialPassword"))
      host.userAttrs);
}
