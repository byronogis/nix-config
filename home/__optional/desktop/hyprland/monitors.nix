{ config, ... }: {
  wayland.windowManager.hyprland.settings = {
    monitor = map
      (m:
        let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString m.x}x${toString m.y}";
        in
        "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
      )
      # @see modules/home-manager/monitors.nix
      (config.monitors);
  };
}
