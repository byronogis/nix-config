{ lib
, config
, host
, localLib
, ...
}:
let
  persistence = localLib.setHostPersistence {
    inherit host;
    settings = {
      directories = [
        # ...
      ];
      files = [
        "/var/lib/zerotier-one/identity.public"
        "/var/lib/zerotier-one/identity.secret"
      ];
    };
  };
in
{
  imports = [
    persistence
  ];

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      # ...
      # TODO maybe config.sops.secrets.nix-extra-access-tokens.path
      "272f5eae1680f5b3"
    ];
  };
}
