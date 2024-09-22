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
          "${pkgs.kitty}/Applications/kitty.app"
          "/Applications/Obsidian.app"
          "/Applications/Microsoft Edge.app"
          "/Applications/Google Chrome.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Feishu.app"
          "/Applications/LarkSuite.app"
        ];
        persistent-others = [
          #
        ];
      };
    };
  };
}