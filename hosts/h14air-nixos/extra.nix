{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  boot.initrd.availableKernelModules = lib.mkForce [ "sd_mod" "sr_mod" ];

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

  # x11 for kde
  services.xserver.enable = true;
  services.displayManager = {
    defaultSession = lib.mkForce "plasmax11";
    sddm = {
      wayland.enable = lib.mkForce false;
      enableHidpi = lib.mkForce false;
    };
  };

}
