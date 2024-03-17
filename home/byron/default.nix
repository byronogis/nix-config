# See https://nix-community.github.io/home-manager/options.xhtml
{ inputs
, outputs
, host
, user
, pkgs
, ...
}: {
  imports = [
    ../__optional/cli
  ];

  home = {
    packages = with pkgs; [
      tree
    ];
    file = { };
    sessionPath = [ ];
    sessionVariables = { };
    shellAliases = {
      p = "cd ~/project";
      pp = "cd ~/project/personal";
      pd = "cd ~/project/demo";
    };
  };
}
