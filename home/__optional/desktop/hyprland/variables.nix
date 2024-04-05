# @see https://wiki.hyprland.org/Configuring/Variables/

{ lib, config, ... }: {
  wayland.windowManager.hyprland.settings = {
    general = {
      layout = "master";
      resize_on_border = true;
    };
    decoration = {
      blur = { };
    };
    animations = { };
    input = {
      touchpad = { };
      touchdevice = { };
      tablet = { };
    };
    gestures = { };
    group = {
      groupbar = { };
    };
    misc = { };
    binds = { };
    xWayland = { };
    openGL = { };
    debug = { };
  };
}
