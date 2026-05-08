{
  outputs,
  ctx,
  ...
}:
let
  hostAllowedPorts = outputs.lib.optionals (ctx.host ? "allowedPorts") ctx.host.allowedPorts;
  hostAllowedPortRanges = outputs.lib.optionals (
    ctx.host ? "allowedPortRanges"
  ) ctx.host.allowedPortRanges;
in
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ] ++ hostAllowedPorts;
    allowedUDPPorts = [ ] ++ hostAllowedPorts;
    allowedTCPPortRanges = [ ] ++ hostAllowedPortRanges;
    allowedUDPPortRanges = [ ] ++ hostAllowedPortRanges;
  };
}
