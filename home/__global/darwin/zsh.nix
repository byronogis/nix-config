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
        #  TODO https://github.com/LnL7/nix-darwin?tab=readme-ov-file#updating
        BUILD = "sudo darwin-rebuild switch --option eval-cache false --show-trace --flake NCP";
      };
    };
  };
}
