{ pkgs, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  home.packages = with pkgs; [
    libnotify # notify-send
  ];

  xdg.portal.enable = true;
}
