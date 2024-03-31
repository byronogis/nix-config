{ config, ... }: {
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];
    bind = [
      "SUPER,Return,exec,${config.home.sessionVariables.TERMINAL}"
    ];
  };
}
