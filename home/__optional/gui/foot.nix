{ ... }: {
  programs.foot = {
    enable = true;
    server.enable = false;
    # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
    settings = {
      main = {
        font = "monospace:size=12";
      };

      cursor = {
        style = "beam"; # block underline beam
        blink = "yes";
      };
    };
  };
}
