{ outputs, user, lib, localLib, ... }: {
  imports = [ ] ++
    localLib.importAllFromPath ./. ++
    (builtins.attrValues outputs.homeManagerModules);
}
