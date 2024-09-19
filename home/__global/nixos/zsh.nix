# See https://zsh.sourceforge.io/Doc/Release/Options.html
{ lib
, pkgs
, host
, user
, ...
}: {
  programs = {
    zsh = {
      shellAliases = {
        BUILD = "sudo nixos-rebuild switch --option eval-cache false --show-trace --flake NCP";
      };
    };
  };
}
