{ lib
, host
, ...
}:
let
  hostAllowedPorts = lib.optionals (host ? "allowedPorts") host.allowedPorts;
in
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ] ++ hostAllowedPorts;
    allowedUDPPorts = [ ] ++ hostAllowedPorts;
  };
}
