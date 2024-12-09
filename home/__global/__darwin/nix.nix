{ lib
, pkgs
, host
, user
, config
, ...
}: {
  nix = {
    extraOptions = ''
      !include ${config.sops.secrets.nix-extra-access-tokens.path}
    '';
  };
}
