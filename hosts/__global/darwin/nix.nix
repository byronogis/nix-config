{ inputs
, lib
, pkgs
, config
, host
, ...
}: {
  nix = {
    gc = {
      interval.Day = 7;
    };
  };
}
