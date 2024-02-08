{ config, pkgs, constants, ... }:

{
  home = {
    username = constants.username;
    homeDirectory = "/home/${constants.username}";
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

  programs = {
    git = {
      enable = true;
      userName = constants.username;
      userEmail = constants.useremail;
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
