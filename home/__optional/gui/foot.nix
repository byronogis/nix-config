{...}: {
  programs.foot = {
    enable = true;
    server.enable = false;
    # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
    settings = {};
  };
}
