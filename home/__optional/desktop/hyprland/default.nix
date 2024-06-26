{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ../__wayland

    # settings
    ./variables.nix
    ./binds.nix
    ./monitors.nix
    ./workspace.nix
    ./dwindle-layout.nix
    ./master-layout.nix

    ../../gui/foot.nix # terminal
    ../../gui/wofi.nix # launcher
    ../../gui/waybar.nix # status bar
    ../../gui/mako.nix # notification daemon
    ../../gui/wlogout.nix # logout dialogue
  ];

  xdg.portal = {
    configPackages = [ config.wayland.windowManager.hyprland.package ];
  };

  home.sessionVariables = {
    __WM_TERMINAL = "foot";
    __WM_LAUNCHER = "wofi -S drun -x 10 -y 10 -W 25% -H 60%";
    __WM_STATUS_BAR = "waybar";
    __WM_NOTIFICATION_DAEMON = "mako";
    __WM_LOGOUT_DIALOGUE = "wlogout";
    __WM_BROWSER = "firefox";

  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ ];
    # @see https://wiki.hyprland.org/Configuring
    settings = {
      # Defining variables
      "$MOD" = "SUPER";
    };
    extraConfig = "";
  };
}
