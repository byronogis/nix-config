# This file (and the nixos directory) holds config that i use on all nixos hosts
{
  inputs,
  outputs,
  ctx,
  ...
}:
{
  imports = [ ] ++ outputs.lib._local.import ./. { };
}
