# See https://nix-community.github.io/home-manager/options.xhtml

{inputs, outputs, host, user, pkgs, ... }: {
  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
    packages = with pkgs; [
      tree
      fastfetch
      fnm
      yazi
    ];
    file = {};
    sessionPath = [];
    sessionVariables = {};
    shellAliases = {};
  };
  programs = {
    git = {
      enable = true;
      userName = user.usernameAlternative;
      userEmail = user.useremail;
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
