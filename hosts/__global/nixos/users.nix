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
            }
        )
        host.userAttrs;

    defaultUserShell = pkgs.zsh;
  };
}
