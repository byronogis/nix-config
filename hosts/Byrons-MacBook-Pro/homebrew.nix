{ inputs
, lib
, pkgs
, config
, host
, ...
}: {
  homebrew = {
    taps = [
      "v2raya/v2raya"
    ];

    brews = [
      "v2raya"
      "openvpn"
    ];

    casks = [
      "visual-studio-code"
      "windterm"
      "clash-verge-rev"
      "firefox"
      "google-chrome"
      "microsoft-edge"
      "discord"
      "feishu"
      "lark"
    ];

    masApps = {
      # Xcode = 497799835;
    };
  };
}
