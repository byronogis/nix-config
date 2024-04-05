# See https://wiki.hyprland.org/Configuring/Master-Layout/

{ config, ... }: {
  wayland.windowManager.hyprland.settings = {
    master = {
      mfact = 0.6;
      new_is_master = false;
      new_on_top = false;
      orientation = "left";
    };
  };
}
