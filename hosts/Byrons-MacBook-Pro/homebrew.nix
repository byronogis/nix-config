{ inputs
, lib
, localLib
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
      "android-studio"
      "wechatwebdevtools"
      "hbuilderx"

      "nutstore" # 坚果云
      "keepassxc"

      "discord"
      # "feishu"
      # "lark"
      "wechatwork"
      "wechat"
    ] ++ map localLib.mkCaskGreedy [
      "visual-studio-code"
      "cursor"
      "obsidian"

      # "openvpn-connect"
      # "zerotier-one"
      "clash-verge-rev"

      "firefox"
      "google-chrome"
      "microsoft-edge"

      "obs"
      "iina" # video player
      "stats" # system monitor
      "utools"
      "karabiner-elements"
      "jordanbaird-ice" # manage menu bar icons
      "pearcleaner" # app cleaner
    ];

    masApps = {
      Xcode = 497799835;
    };
  };
}
