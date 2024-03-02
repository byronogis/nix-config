{ user, ... }: {
  programs = {
    git = {
      enable = true;
      userName = user.usernameAlternative;
      userEmail = user.useremail;
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };
  };
}
