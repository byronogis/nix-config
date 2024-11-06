{ lib
, config
, pkgs
, host
, localLib
, ...
}:
let
  persistence = localLib.setHostPersistence {
    inherit host;
    settings = {
      directories = [
        "/etc/v2raya"
      ];
    };
  };
in
{
  imports = [
    persistence
  ];

  services.v2raya.enable = true;
  networking.firewall.allowedTCPPorts = [
    2017 # default web ui
  ];
}
