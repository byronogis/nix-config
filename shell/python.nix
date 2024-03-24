{ pkgs, ... }: {
  languages.python = {
    enable = true;
    package = pkgs.python3Full;
    poetry = {
      enable = true;
    };
  };
}
