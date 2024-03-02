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
    ../common/optional/cli/bat.nix
    ../common/optional/cli/direnv.nix
    ../common/optional/cli/fastfetch.nix
    ../common/optional/cli/fzf.nix
    ../common/optional/cli/git.nix
    ../common/optional/cli/starship.nix
    ../common/optional/cli/zsh.nix
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
