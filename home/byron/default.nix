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

    ../__optional/desktop/hyprland
  ];

  home = {
    packages = with pkgs; [ ];
    file = { };
    sessionPath = [ ];
    sessionVariables = { };
    shellAliases = { };
  };

  programs.zsh.shellGlobalAliases = {
    P = "~/project";
    PP = "~/project/personal";
    PD = "~/project/demo";
    PC = "~/project/clone";
    NCP = "~/project/personal/nix-config";
  };
}
