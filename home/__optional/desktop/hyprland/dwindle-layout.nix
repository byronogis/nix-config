# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/#config

{ config, ... }: {
  wayland.windowManager.hyprland.settings = {
    dwindle = {
      force_split = 2; # always split to the right (new = right or bottom)
      preserve_split = true;
    };
  };
}
