{ pkgs, ... }: {
  imports = [
    ../__base
  ];

  home.packages = with pkgs; [
    wev # debugging events
  ];

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-wlr
  ];
}
