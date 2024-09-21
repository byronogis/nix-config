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
    settings = {
      # TODO Disable auto-optimise-store because of this issue:
      #   https://github.com/NixOS/nix/issues/7273
      # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
      auto-optimise-store = false;
    };
  };
}
