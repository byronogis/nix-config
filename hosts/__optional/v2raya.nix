{
  config,
  pkgs,
  outputs,
  ctx,
  ...
}:
let
  persistence = outputs.lib._local.setHostPersistence {
    inherit (ctx) host;
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
