{ pkgs, ... }: {
  home.packages = with pkgs; [
    pavucontrol # PulseAudio Volume Control (used by waybar now)
  ];
}
