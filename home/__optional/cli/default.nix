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
    just
    tree
    wget
    fd
    ripgrep # rg
    ffmpeg
  ];
}
