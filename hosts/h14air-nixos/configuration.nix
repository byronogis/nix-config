{ inputs
, config
, lib
, host
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ./hyperv.nix

    ../__optional/systemd-boot.nix
    ../__optional/nix-ld.nix
    # ../__optional/v2raya.nix
    ../__optional/podman.nix
    # ../__optional/zerotierone.nix
  ];

  networking.firewall.enable = lib.mkForce false;

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024; # in megabytes
    }
  ];

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  system.stateVersion = "24.05";
}
