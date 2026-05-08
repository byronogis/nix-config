{ ctx, ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name =
            if (ctx.user ? "usernameKeyForGit") then
              ctx.user.${ctx.user.usernameKeyForGit}
            else
              ctx.user.fullname;
          email = ctx.user.useremail;
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        diff.algorithm = "histogram";
      };
      signing.format = "openpgp";

      lfs.enable = true;
    };
  };
}
