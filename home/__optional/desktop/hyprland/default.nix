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
    settings = {
      monitor = map
        (m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in
          "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
        )
        (config.monitors);

      workspace = map
        (m:
          "${m.name},${m.workspace}"
        )
        (lib.filter (m: m.enabled && m.workspace != null) config.monitors);
    };
    extraConfig = "";
  };

  # home.packages = with pkgs; [
  #   waybar
  #   swaylock
  #   wlogout
  # ];
}
