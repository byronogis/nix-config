{ pkgs, ... }: {
  languages.python = {
    enable = true;
    package = pkgs.python3;
    uv = {
      enable = true;
    };
  };
}
