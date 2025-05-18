{ inputs
, lib
, pkgs
, config
, host
, ...
}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      #
    ];

    brews = [
      #
    ];

    casks = [
      #
    ];

    masApps = {
      #
    };
  };

  programs.zsh.shellInit = ''
    # see https://docs.brew.sh/Installation#post-installation-steps
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';
}
