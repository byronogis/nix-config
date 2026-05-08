{
  outputs,
  ctx,
  pkgs,
  ...
}:
{
  imports =
    [ ]
    ++ outputs.lib._local.import ./. {
      exclude = [
        "mise\\.nix"
      ];
    };

  home.packages = with pkgs; [
    tree
    wget
    fd
    ripgrep # rg
  ];
}
