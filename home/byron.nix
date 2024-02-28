# See https://nix-community.github.io/home-manager/options.xhtml

{inputs, outputs, host, pkgs, ... }: 
let
  # TODO get <byron> automatic
  user = host.userAttrs.byron;
in
{
  _module.args = {
    inherit user;
  };
  
  imports = [
    ./global
    ./feature/cli/git.nix
    ./feature/cli/starship.nix
    ./feature/cli/zsh.nix
  ];

  home = {
    packages = with pkgs; [
      tree
      fastfetch
      fnm
      yazi
    ];
    file = {};
    sessionPath = [];
    sessionVariables = {};
    shellAliases = {};
  };
}
