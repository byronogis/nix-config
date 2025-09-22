{ host
, lib
, config
, pkgs
, ...
}: {
  system = {
    defaults = {
      dock = {
        persistent-apps = lib.mkAfter [
          "${pkgs.alacritty}/Applications/alacritty.app"
          "/Applications/Obsidian.app"
          # "/Applications/Microsoft Edge.app"
          "/Applications/Google Chrome.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/WeChat.app"
        ];
        persistent-others = [
          #
        ];
      };
    };
  };
}
