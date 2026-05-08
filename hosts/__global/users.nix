{
  ctx,
  outputs,
  config,
  pkgs,
  ...
}:
{
  users = {
    users = builtins.mapAttrs (username: user: {
      openssh.authorizedKeys.keys = [
        # ...
      ]
      ++ (
        let
          sshAuthorizedKeysFile = ../../home/${username}/ssh-authorized-keys.pub;
          isExit = builtins.pathExists sshAuthorizedKeysFile;
        in
        if (isExit) then (outputs.lib.splitString "\n" (builtins.readFile sshAuthorizedKeysFile)) else ""
      );
      shell = pkgs.zsh;
    }) ctx.host.userAttrs;
  };

  programs.zsh.enable = true;
}
