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

    ../../gui/foot.nix
    ../../gui/wofi.nix
    ../../gui/waybar.nix
    ../../gui/mako.nix
  ];

  xdg.portal = {
    extraPortals = [ pkgs.inputs.hyprland.xdg-desktop-portal-hyprland ];
    configPackages = [ config.wayland.windowManager.hyprland.package ];
  };

  home.sessionVariables = {
    __WM_TERMINAL = "foot";
    __WM_LAUNCHER = "wofi -S drun -x 10 -y 10 -W 25% -H 60%";
    __WM_STATUS_BAR = "waybar";

  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.inputs.hyprland.hyprland.override { wrapRuntimeDeps = false; };
    systemd = {
      enable = true;
      # Same as default, but stop graphical-session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    plugins = [ ];
    # @see https://wiki.hyprland.org/Configuring
    settings = {
      # Defining variables
      "$MOD" = "SUPER";
    };
    extraConfig = "";
  };
}
