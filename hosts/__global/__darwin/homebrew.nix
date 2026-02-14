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
      "mas" # Mac App Store CLI
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
    eval "$(${config.homebrew.prefix}/bin/brew shellenv)"
  '';
}
