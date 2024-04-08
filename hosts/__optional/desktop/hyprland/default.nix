{ ... }: {
  imports = [
    ../__base
    ../../greetd.nix
  ];

  programs.hyprland.enable = true;
}
