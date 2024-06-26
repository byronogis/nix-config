{ lib, config, host, ... }: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      # ...
      # TODO maybe config.sops.secrets.nix-extra-access-tokens.path
    ];
  };

  environment = lib.optionalAttrs (config.environment ? "persistence") {
    persistence."${host.persistencePath}" = {
      directories = [
        # ...
      ];
    };
  };
}
