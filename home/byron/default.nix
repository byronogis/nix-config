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
    # ../__optional/fcitx5

    # ../__optional/desktop/hyprland
    # ../__optional/gui/firefox.nix
  ];

  home = {
    packages = with pkgs; [ ];
    file = {
      "project/.envrc".text = "use flake ~/project/personal/nix-config#byron --impure";
    };
    sessionPath = [ ];
    sessionVariables = { };
    shellAliases = { };
  };

  programs.zsh.shellGlobalAliases = {
    P = "~/project";
    PP = "~/project/personal";
    PD = "~/project/demo";
    PC = "~/project/clone";
    PW = "~/project/work";
    NCP = lib.mkForce "~/project/personal/nix-config";
  };

  programs.git.includes = [
    {
      path = "~/project/work/.gitconfig";
      condition = "gitdir:~/project/work/";
    }
  ];
}
