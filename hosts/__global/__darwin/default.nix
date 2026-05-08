# This file (and the nixos directory) holds config that i use on all nixos hosts
{
  inputs,
  outputs,
  ctx,
  ...
}:
{
  imports = [ ] ++ outputs.lib._local.import ./. { };

  networking.computerName = ctx.host.hostname;

  # Enable TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = ctx.host.system;
}
