{ lib, user, ... }: {
  programs = {
    git = {
      enable = true;
      userName =
        if (user ? "usernameKeyForGit")
        then user.${user.usernameKeyForGit}
        else user.username;
      userEmail = user.useremail;
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };
  };
}
