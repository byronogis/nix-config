{ inputs
, lib
, pkgs
, config
, host
, ...
}: {
  nix = {
    gc = {
      dates = "weekly";
    };
  };
}
