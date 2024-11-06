{ config
, host
, ...
}:
let
  dockerEnabled = config.virtualisation.docker.enable;
in
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = !dockerEnabled;
    dockerSocket.enable = !dockerEnabled;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment = lib.optionalAttrs (config.environment ? "persistence") {
    persistence."${host.persistencePath}" = {
      directories = [
        "/var/lib/containers"
      ];
    };
  };
}
