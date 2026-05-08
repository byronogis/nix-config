{
  config,
  outputs,
  ctx,
  ...
}:
let
  persistence = outputs.lib._local.setHostPersistence {
    inherit (ctx) host;
    settings = {
      directories = [
        "/var/lib/private/ollama"
      ];
    };
  };
in
{
  imports = [
    persistence
  ];

  services.ollama = {
    enable = true;
    # acceleration = "rocm";
  };
}
