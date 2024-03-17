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
    };
  };

  programs.zsh.shellGlobalAliases = {
    P = "~/project";
    PP = "~/project/personal";
    PD = "~/project/demo";
    NCP = "~/project/personal/nix-config";
  };
}
