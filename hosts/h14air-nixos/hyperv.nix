{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  boot.initrd.availableKernelModules = lib.mkForce [ "sd_mod" "sr_mod" ];

  virtualisation.hypervGuest.enable = true;

  networking = {
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.100.100";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.100.1";
      interface = "eth0";
    };

    nameservers = [
      "192.168.100.1"
    ];
  };

}
