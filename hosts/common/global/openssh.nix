{ outputs
, lib
, config
, host
, ...
}:
let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = hostname: ../../${hostname}/ssh_host_ed25519_key.pub;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at ${host.persistencePath}
  hasOptinPersistence = config.environment ? "persistence" ? host.persistencePath;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
    hostKeys = [
      {
        bits = 4096;
        path = "${lib.optionalString hasOptinPersistence host.persistencePath}/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${lib.optionalString hasOptinPersistence host.persistencePath}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    # Each hosts public key
    knownHosts =
      builtins.mapAttrs
        (hostname: _: {
          publicKeyFile = pubKey hostname;
          extraHostNames =
            lib.optional
              (
                hostname == config.networking.hostName
              ) "localhost"; # Alias for localhost if it's the same host
        })
        outputs.nixosConfigurations;
  };
}
