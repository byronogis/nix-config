{ lib
, pkgs
, host
, user
, ...
}: {
  programs.mise = {
    enable = true;
    globalConfig = {};
    settings = {};
  };

}
