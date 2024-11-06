{ config
, host
, localLib
, ...
}:
let
  dockerEnabled = config.virtualisation.docker.enable;
  persistence = localLib.setHostPersistence {
    inherit host;
    settings = {
      directories = [
        "/var/lib/containers"
      ];
    };
  };
in
{
  imports = [
    persistence
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = !dockerEnabled;
    dockerSocket.enable = !dockerEnabled;
    defaultNetwork.settings.dns_enabled = true;
  };
}
