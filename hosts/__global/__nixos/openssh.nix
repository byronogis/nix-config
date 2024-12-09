{ outputs
, lib
, config
, host
, ...
}:
let
  pubKey = hostname: ./../../${hostname}/ssh_host_ed25519_key.pub;
in
{
  programs.ssh = {
    # Each hosts public key
    knownHosts =
      builtins.mapAttrs
        (hostname: _: {
          publicKeyFile = pubKey hostname;
          extraHostNames =
            lib.optional
              (
                hostname == host.hostname
              )
              "localhost"; # Alias for localhost if it's the same host
        })
        outputs.nixosConfigurations;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
    hostKeys = [
      {
        bits = 4096;
        path = "${lib.optionalString host.impermanence host.persistencePath}/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${lib.optionalString host.impermanence host.persistencePath}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
