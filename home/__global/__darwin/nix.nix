{
  ctx,
  pkgs,
  config,
  ...
}:
{
  nix = {
    extraOptions = ''
      !include ${config.sops.secrets.nix-extra-access-tokens.path}
    '';
  };
}
