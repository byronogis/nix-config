{ lib
, host
, user
, ...
}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}
