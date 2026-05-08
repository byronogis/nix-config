{
  config,
  outputs,
  ctx,
  ...
}:
let
  dockerEnabled = config.virtualisation.docker.enable;
  persistence = outputs.lib._local.setHostPersistence {
    inherit (ctx) host;
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
