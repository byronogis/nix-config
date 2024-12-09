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
    extraOptions = ''
      !include ${config.sops.secrets.nix-extra-access-tokens.path}
    '';
  };
}
