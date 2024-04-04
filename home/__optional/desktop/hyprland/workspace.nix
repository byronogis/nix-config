{ ... }: {
  wayland.windowManager.hyprland.settings = {
    workspace = map
      (m:
        "${m.name},${m.workspace}"
      )
      (lib.filter (m: m.enabled && m.workspace != null) config.monitors);
  };
}
