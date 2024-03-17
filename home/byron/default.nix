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
      P = "cd ~/project";
      PP = "cd ~/project/personal";
      PD = "cd ~/project/demo";
    };
  };

  programs.zsh.shellGlobalAliases = {
    NCP = "~/project/personal/nix-config";
  };
}
