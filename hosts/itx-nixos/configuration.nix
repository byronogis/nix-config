{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix

    ../__optional/systemd-boot.nix
    ../__optional/nix-ld.nix
    ../__optional/vsftpd.nix
    ../__optional/v2raya.nix
    ../__optional/zerotierone.nix
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

  services.openvpn = {
    servers = {
      # systemctl status openvpn-byron
      byron = {
        config = "config /home/byron/Document/openvpn/byron.ovpn";
        autoStart = false;
      };
    };
  };


  # TODO cloudflared
  # services.cloudflared.enable = true;

  # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
