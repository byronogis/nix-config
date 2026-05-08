{
  inputs,
  pkgs,
  config,
  ctx,
  ...
}:
{
  nix = {
    gc = {
      dates = "weekly";
    };
    extraOptions = ''
      !include ${config.sops.secrets.nix-extra-access-tokens.path}
    '';
  };
}
