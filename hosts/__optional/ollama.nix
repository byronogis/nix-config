{ lib, config, host, ... }: {
  services.ollama = {
    enable = true;
    # acceleration = "rocm";
  };

  environment = lib.optionalAttrs (config.environment ? "persistence") {
    persistence."${host.persistencePath}" = {
      directories = [
        "/var/lib/private/ollama"
      ];
    };
  };
}
