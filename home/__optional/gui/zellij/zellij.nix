{ ... }: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;


    settings = {
      #
    };
  };

  xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
}
