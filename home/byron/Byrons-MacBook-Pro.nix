# See https://nix-community.github.io/home-manager/options.xhtml
{ inputs
, outputs
, host
, user
, pkgs
, lib
, ...
}: {
  imports = [
    ../__optional/desktop/__base/font.nix
    ../__optional/gui/alacritty.nix
    # ../__optional/gui/kitty.nix
    # ../__optional/gui/zellij/zellij.nix
  ];

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  };
}
