{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ../__base

    ./binds.nix
    ./monitors.nix
    ./workspace.nix

    ../../gui/foot.nix
    ../../gui/wofi.nix
  ];

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.inputs.hyprland.xdg-desktop-portal-hyprland
    ];
    configPackages = [ config.wayland.windowManager.hyprland.package ];
  };

  home.sessionVariables = {
    __TERMINAL = "foot";
    __LAUNCHER = "wofi -S drun -x 10 -y 10 -W 25% -H 60%";

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
}
