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
    };
  };
}
