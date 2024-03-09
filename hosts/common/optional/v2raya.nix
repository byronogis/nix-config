{ pkgs, host, ... }: {
  services.v2raya.enable = true;
  networking.firewall.allowedTCPPorts = [
    2017 # default web ui
  ];
  environment.persistence = {
    "${host.persistencePath}" = {
      directories = [
        "/etc/v2raya"
      ];
    };
  };
}
