# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  ctx,
  ...
}:
{
  imports = [ ] ++ outputs.lib._local.import ./. { };

  networking.hostName = ctx.host.hostname;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
