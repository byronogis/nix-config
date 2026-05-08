# See https://zsh.sourceforge.io/Doc/Release/Options.html
{
  ctx,
  pkgs,
  ...
}:
{
  programs = {
    zsh = {
      shellAliases = {
        BUILD = "sudo darwin-rebuild switch --option eval-cache false --show-trace --flake NCP";
        UPDATE = "nix flake update --flake NCP --commit-lock-file";
      };
    };
  };
}
