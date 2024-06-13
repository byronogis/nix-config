{ lib
, host
, ...
}:
let
  hostAllowedPorts = lib.optionals (host ? "allowedPorts") host.allowedPorts;
  hostAllowedPortRanges = lib.optionals (host ? "allowedPortRanges") host.allowedPortRanges;
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
