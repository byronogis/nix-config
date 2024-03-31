{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ./binds.nix
    ../../gui/kitty.nix
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.inputs.hyprland.xdg-desktop-portal-hyprland ];
    configPackages = [ config.wayland.windowManager.hyprland.package ];
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
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
    settings = { };
    extraConfig = "";
  };

  # home.packages = with pkgs; [
  #   waybar
  #   swaylock
  #   wlogout
  # ];
}
