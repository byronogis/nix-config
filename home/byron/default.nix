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
  ];

  home = {
    packages = with pkgs; [
      # nodejs-slim # managed by fnm
      deno
      bun
    ];
    file = {
      # "project/.envrc".text = "use flake ~/project/personal/nix-config#byron --no-pure-eval";
      "project/demo/go/.envrc".text = "use flake ~/project/personal/nix-config#go --no-pure-eval";
      "project/demo/rust/.envrc".text = "use flake ~/project/personal/nix-config#rust --no-pure-eval";
      "project/demo/python/.envrc".text = "use flake ~/project/personal/nix-config#python --no-pure-eval";
      "project/demo/flutter/.envrc".text = "use flake ~/project/personal/nix-config#flutter --no-pure-eval";
    };
    sessionPath = [ ];
    sessionVariables = { };
    shellAliases = {
      # TODO flag to enable/disable
      denoo = "deno run --allow-all --unstable-sloppy-imports --unstable-byonm";
      gitap = "git add --patch";
      ll = "ls -la";
    };
  };

  programs.zsh.shellGlobalAliases = {
    P = "~/project";
    PP = "~/project/personal";
    PD = "~/project/demo";
    PC = "~/project/clone";
    PW = "~/project/work";
    NCP = lib.mkForce "~/project/personal/nix-config";
    DL = "~/Downloads";
  };

  programs.git.includes = [
    {
      path = "~/project/work/.gitconfig";
      condition = "gitdir:~/project/work/";
    }
  ];
}
