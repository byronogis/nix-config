# See https://nix-community.github.io/home-manager/options.xhtml
{
  inputs,
  outputs,
  ctx,
  pkgs,
  ...
}:
{
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
      # "projects/.envrc".text = "use flake ~/projects/personal/nix-config#byron --no-pure-eval";
    };
    sessionPath = [
      "$HOME/.vite-plus/bin" # for vite-plus binaries
      "$HOME/.bun/bin" # for bun global packages
      "$HOME/.deno/bin" # for deno global packages
      "$HOME/.local/bin" # for user installed binaries
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
    P = "~/projects";
    PP = "~/projects/personal";
    PD = "~/projects/demo";
    PC = "~/projects/clone";
    PW = "~/projects/work";
    NCP = outputs.lib.mkForce "~/projects/personal/nix-config";
    DL = "~/Downloads";
  };

  programs.git = {
    includes = [
      {
        path = "~/projects/work/.gitconfig";
        condition = "gitdir:~/projects/work/";
      }
    ];
    ignores = [
      ".devenv"
      ".direnv"
      ".sisphus"
    ];
  };
}
