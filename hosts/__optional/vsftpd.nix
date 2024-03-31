{ host, ... }: {
  services.vsftpd = {
    enable = true;
    writeEnable = true;
    userlist = builtins.attrNames host.userAttrs;
    userlistEnable = true;
    localUsers = true;
    extraConfig = ''
      pasv_min_port=56250
      pasv_max_port=56260
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 20 21 ];
    allowedTCPPortRanges = [{ from = 56250; to = 56260; }];
    connectionTrackingModules = [ "ftp" ];
  };
}
