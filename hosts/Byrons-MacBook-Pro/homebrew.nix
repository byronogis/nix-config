{ inputs
, lib
, pkgs
, config
, host
, ...
}: {
  homebrew = {
    taps = [
      # "v2raya/v2raya"
    ];

    brews = [
      # "v2ray"
      # "v2raya"
    ];

    casks = [
      "visual-studio-code"
      "cursor"

      "android-studio"
      "wechatwebdevtools"

      "obsidian"
      "nutstore" # 坚果云
      "keepassxc"

      # "openvpn-connect"
      # "zerotier-one"
      "clash-verge-rev"

      "firefox"
      "google-chrome"
      "microsoft-edge"

      "discord"
      "feishu"
      "lark"
      "wechat"

      "obs"
      "iina" # video player
      "stats" # system monitor
      "utools"
      # "karabiner-elements"
      "jordanbaird-ice" # manage menu bar icons
    ];

    masApps = {
      Xcode = 497799835;
    };
  };
}
