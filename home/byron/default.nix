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
    ../common/optional/cli
  ];

  home = {
    packages = with pkgs; [
      tree
      fnm
    ];
    file = { };
    sessionPath = [ ];
    sessionVariables = { };
    shellAliases = { };
  };
}
