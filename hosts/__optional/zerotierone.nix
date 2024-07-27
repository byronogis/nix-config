{ lib, config, host, ... }: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      # ...
      # TODO maybe config.sops.secrets.nix-extra-access-tokens.path
      "272f5eae1680f5b3"
    ];
  };

  environment = lib.optionalAttrs (config.environment ? "persistence") {
    persistence."${host.persistencePath}" = {
      directories = [
        # ...
      ];
      files = [
        "/var/lib/zerotier-one/identity.public"
        "/var/lib/zerotier-one/identity.secret"
      ];
    };
  };
}
