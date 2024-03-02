{ user, ... }: {
  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
    stateVersion = "23.11";
  };
  programs = {
    home-manager.enable = true;
  };
}
