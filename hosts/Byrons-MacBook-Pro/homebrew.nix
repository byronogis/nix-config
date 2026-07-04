{
  inputs,
  outputs,
  ctx,
  pkgs,
  config,
  ...
}:
{
  homebrew = {
    taps = [
      "tw93/tap"
    ];

    brews = [
      "tesseract" # OCR
      "tesseract-lang" # OCR

      "mole"
    ];

    casks = [
      "visual-studio-code"
      "zed"
      "podman-desktop"
      "gitbutler"
      "tw93/tap/kakuku"
      "letos" # "sqlitestudio"
      "dbeaver-community"

      "obs"
      "iina" # video player
      "stats" # system monitor
      "keka" # archive utility
      "karabiner-elements"
      "jordanbaird-ice" # manage menu bar icons
      "pearcleaner" # app cleaner
      "switchhosts" # hosts manager
      "raycast"
      "cryptomator" # encrypt files
      "squirrel-app" # input method
      "background-music" # per-app volume control
      "nutstore" # 坚果云
      "keepassxc"
      "obsidian"
      "calibre"
      "qlmarkdown" # Quick Look plugin for Markdown files

      "discord"
      "feishu"
      # "lark"
      "wechatwork"
      "wechat"
      "tencent-meeting"

      # "openvpn-connect"
      # "zerotier-one"
      # "clash-verge-rev"
      "karing"
      "wireshark-app"

      "firefox"
      "google-chrome"
    ]
    ++ map outputs.lib._local.mkCaskGreedy [
    ];

    masApps = {
      # Xcode = 497799835;
      "Longshot - 截图 & OCR文字识别" = 6450262949;
      "文件夹夹" = 6736857712;
    };
  };
}
