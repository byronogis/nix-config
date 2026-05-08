{ outputs, config, ... }:
{
  wayland.windowManager.hyprland.settings = {
    workspace = map (m: "${m.name},${m.workspace}") (
      outputs.lib.filter (m: m.enabled && m.workspace != null) config.monitors
    );
  };
}
