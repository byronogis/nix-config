{ pkgs, ... }: {
  imports = [
    ../__base
  ];

  services.desktopManager.plasma6 = {
    enable = true;
  };

  services.displayManager = {
    enable = true;
    sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      settings = {
        # 
      };
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    oxygen
  ];
}
