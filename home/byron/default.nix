# See https://nix-community.github.io/home-manager/options.xhtml
{ inputs
, outputs
, host
, user
, pkgs
, ...
}: {
  imports = [
    ../common/global
    ../common/feature/cli/bat.nix
    ../common/feature/cli/direnv.nix
    ../common/feature/cli/fastfetch.nix
    ../common/feature/cli/fzf.nix
    ../common/feature/cli/git.nix
    ../common/feature/cli/starship.nix
    ../common/feature/cli/zsh.nix
  ];

  home = {
    packages = with pkgs; [
      tree
      fnm
      yazi
    ];
    file = { };
    sessionPath = [ ];
    sessionVariables = { };
    shellAliases = { };
  };
}
