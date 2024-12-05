{ pkgs, lib, ... }: {
  # languages.javascript = {
  #   enable = true;
  #   bun.enable = true;
  #   corepack.enable = true;
  # };

  packages = with pkgs; [
    # nodejs-slim # managed by fnm
    deno
    bun
  ];
}
