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
      "v2ray"
      "v2raya"
    ];

    casks = [
      "visual-studio-code"
      "cursor"

      "obsidian"

      "ollama"

      "openvpn-connect"
      "zerotier-one"
      "clash-verge-rev"

      "firefox"
      "google-chrome"
      "microsoft-edge"

      "discord"
      "feishu"
      "lark"

      "obs"
      "iina"
      "stats"
      "utools"
    ];

    masApps = {
      Xcode = 497799835;
    };
  };
}
