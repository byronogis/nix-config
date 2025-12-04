{ pkgs, lib, localLib, ... }: {
  imports = [ ] ++ localLib.import ./. {
    exclude = [
      "mise\\.nix"
    ];
  };

  home.packages = with pkgs; [
    tree
    wget
    fd
    ripgrep
  ];
}
