{ user, ... }: {
  programs = {
    git = {
      enable = true;
      userName = user.usernameAlternative;
      userEmail = user.useremail;
    };
  };
}
