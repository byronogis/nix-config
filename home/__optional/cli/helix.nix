{ lib
, pkgs
, config
, host
, user
, ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
        };
        indent-guides = {
          render = true;
        };
      };
      keys.normal = {
        # [auto wrap](https://github.com/helix-editor/helix/issues/136#issuecomment-1925898113)
        space.W = [ ":toggle soft-wrap.enable" ":redraw" ];
      };
    };
  };
}
