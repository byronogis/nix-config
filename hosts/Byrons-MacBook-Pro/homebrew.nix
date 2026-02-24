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
      "fastrepl/hyprnote"
    ];

    brews = [
      # "v2ray"
      # "v2raya"

      "tesseract" # OCR
      "tesseract-lang" # OCR

      "mole"
    ];

    casks = [
      "android-studio"
      "wechatwebdevtools"
      "hbuilderx"
      "visual-studio-code"
      "cursor"
      "podman-desktop"
      "gitbutler"

      "obs"
      "iina" # video player
      "stats" # system monitor
      "keka" # archive utility
      # "utools"
      "karabiner-elements"
      "jordanbaird-ice" # manage menu bar icons
      "pearcleaner" # app cleaner
      "switchhosts" # hosts manager
      "raycast"
      "cryptomator" # encrypt files
      "squirrel-app"
      "background-music" # per-app volume control
      "nutstore" # 坚果云
      "keepassxc"
      "obsidian"
      "calibre"
      "fastrepl/hyprnote/hyprnote@nightly"

      "discord"
      # "feishu"
      # "lark"
      "wechatwork"
      "wechat"
      "tencent-meeting"

      # "openvpn-connect"
      # "zerotier-one"
      "clash-verge-rev"

      "firefox"
      "google-chrome"
      # "microsoft-edge"
    ] ++ map localLib.mkCaskGreedy [
    ];

    masApps = {
      # Xcode = 497799835;
      "Longshot - 截图 & OCR文字识别" = 6450262949;
      "文件夹夹" = 6736857712;
    };
  };
}
