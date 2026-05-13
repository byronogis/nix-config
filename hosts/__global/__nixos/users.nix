{
  ctx,
  outputs,
  config,
  pkgs,
  ...
}:
{
  users = {
    users = builtins.mapAttrs (
      username: user:
      let
        hashedPasswordFileValue = outputs.lib.attrByPath [
          "${username}:password"
          "path"
        ] null config.sops.secrets;
      in
      {
        extraGroups = [ "wheel" ];
        # `hashedPassword` > `password` > `hashedPasswordFile` > `initialPassword` > `initialHashedPassword`
        initialPassword = outputs.lib.mkIf (hashedPasswordFileValue == null) user.initialPassword;
        hashedPasswordFile = hashedPasswordFileValue;
        # https://nixos.org/manual/nixos/stable/options#opt-users.users._name_.isNormalUser
        isNormalUser = true;
      }
    ) ctx.host.userAttrs;
  };
}
