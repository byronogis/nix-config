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
          "/Applications/Microsoft Edge.app"
          "/Applications/Google Chrome.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Feishu.app"
          "/Applications/Lark.app"
        ];
        persistent-others = [
          #
        ];
      };
    };
  };
}
