# See https://nix-community.github.io/home-manager/options.xhtml
{ ... }:
{
  imports = [
    ../__optional/tmux/adapters/windows-terminal.nix
  ];
}
