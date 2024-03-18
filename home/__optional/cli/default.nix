{ lib, localLib, ... }: {
  imports = [ ] ++ localLib.importAllFromPath ./.;

  packages = with pkgs; [
    tree
    wget
  ];
}
