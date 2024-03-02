# See https://nix-community.github.io/home-manager/options.xhtml
{ inputs
, outputs
, host
, user
, pkgs
, ...
}: {
  imports = [
    ./global
    ./feature/cli/bat.nix
    ./feature/cli/direnv.nix
    ./feature/cli/fzf.nix
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
    file = { };
    sessionPath = [ ];
    sessionVariables = { };
    shellAliases = { };
  };
}
