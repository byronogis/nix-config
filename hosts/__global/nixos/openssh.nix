{ outputs
, lib
, config
, host
, ...
}: {
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
