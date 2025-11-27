{ pkgs, lib, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  home.packages = with pkgs; [
    tree
    wget
    fd
    ripgrep
  ];
}
