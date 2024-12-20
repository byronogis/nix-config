# Can use in desktop environment
# See https://nixos.wiki/wiki/Fonts
{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.hack
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Sans"
          "Noto Color Emoji"
        ];
        monospace = [
          "Noto Sans Mono CJK SC"
          "Hack Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
