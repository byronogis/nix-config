{ lib
, host
, user
, ...
}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = 0;
      };
    };
  };

}
