{ pkgs, ... }: {
  languages.python = {
    enable = true;
    package = pkgs.python3Full;
    uv = {
      enable = true;
    };
  };
}
