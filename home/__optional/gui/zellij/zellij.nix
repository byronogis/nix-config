{ ... }: {
  programs.zellij = {
    enable = true;

    settings = {
      #
    };
  };

  xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
}
