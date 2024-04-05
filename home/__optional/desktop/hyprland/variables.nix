# @see https://wiki.hyprland.org/Configuring/Variables/

{ lib, config, ... }: {
  wayland.windowManager.hyprland.settings = {
    general = {
      layout = "dwindle"; # master dwindle
      resize_on_border = true;
    };
    decoration = {
      blur = { };
    };
    animations = { };
    input = {
      follow_mouse = 2; # just focus on click
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
