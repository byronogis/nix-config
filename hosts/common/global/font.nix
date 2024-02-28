# See https://nixos.wiki/wiki/Fonts
{pkgs, ...}: {
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];
}
