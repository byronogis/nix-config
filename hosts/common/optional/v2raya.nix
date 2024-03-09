{ pkgs, ... }: {
  services.v2raya.enable = true;
  networking.firewall.allowedTCPPorts = [
    2017 # default web ui
  ];
}
