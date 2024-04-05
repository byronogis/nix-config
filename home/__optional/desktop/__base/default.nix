{ pkgs, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  home.packages = with pkgs; [
    libnotify # notify-send (currently used for test notification)
    pavucontrol # PulseAudio Volume Control
  ];

  xdg.portal.enable = true;
}
