{
  inputs,
  config,
  ctx,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = builtins.head (builtins.attrNames ctx.host.userAttrs);
    usbip = {
      enable = true;
    };
  };
}
