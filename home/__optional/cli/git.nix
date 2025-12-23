{ lib, user, ... }: {
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name =
            if (user ? "usernameKeyForGit")
            then user.${user.usernameKeyForGit}
            else user.fullname;
          email = user.useremail;
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        diff.algorithm = "histogram";
      };

      lfs.enable = true;
    };
  };
}
