{ inputs
, config
, lib
, host
, ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = builtins.head (builtins.attrNames host.userAttrs);
    usbip = {
      enable = true;
    };
  };

  services.fstrim.enable = lib.mkForce false;
}
