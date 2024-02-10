{inputs, outputs, host, user, pkgs, ... }: {
  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
    packages = with pkgs; [
      tree
      fastfetch
      fnm
    ];
    file = {};
    sessionPath = [];
    sessionVariables = {};
    shellAliases = {};
  };
  prograns = {
    git = {
      enable = true;
      userName = "byron";
      userEmail = "byronogis@outlook.com";
    };

    starship = {
      enable = true;
      settings = {
        # add_newline = false;
      };
    };

    zsh = {
      enable = true;
    };

    home-manager.enable = true;
  };
  home.stateVersion = "23.11";
}
