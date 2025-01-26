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

      "android-studio"
      "wechatwebdevtools"

      "obsidian"
      "nutstore" # 坚果云
      "keepassxc"

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
      "wechat"

      "obs"
      "iina" # video player
      "stats" # system monitor
      "utools"
      "karabiner-elements"
    ];

    masApps = {
      Xcode = 497799835;
      iBar = 6443843900; # manage menu bar icons
    };
  };
}
