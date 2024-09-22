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
    ../__optional/gui/zellij.nix
  ];
}
