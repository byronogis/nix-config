# See https://nix-community.github.io/home-manager/options.xhtml
{ inputs
, outputs
, host
, user
, pkgs
, lib
, ...
}: {
  imports = [
    ../__optional/cli

    ../__optional/desktop/kde
    ../__optional/gui/firefox.nix
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
    NCP = lib.mkForce "~/project/personal/nix-config";
  };
}
