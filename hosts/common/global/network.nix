{ host
, ...
}: {
  networking.firewall = {
    enable = true;
  };
}
