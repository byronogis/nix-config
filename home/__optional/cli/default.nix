{ pkgs, lib, localLib, ... }: {
  imports = [ ] ++ localLib.import ./. { };

  home.packages = with pkgs; [
    tree
    wget
    fd
    ripgrep
  ];
}
