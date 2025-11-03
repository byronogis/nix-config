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
      uv
      gh
      act # GitHub Actions locally
    ];
    file = {
      # "project/.envrc".text = "use flake ~/project/personal/nix-config#byron --no-pure-eval";
    };
    sessionPath = [
      "$HOME/.local/bin" # for user installed binaries
      "$HOME/.bun/bin" # for bun global packages
      "$HOME/.deno/bin" # for deno global packages
    ];
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
