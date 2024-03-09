{ host
, ...
}: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [] ++ host.allowedPorts;
    allowedUDPPorts = [] ++ host.allowedPorts;
  };
}
