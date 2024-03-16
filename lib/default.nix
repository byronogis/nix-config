{ lib, ... }: {
  /**
   * Import all nix file(module) from a given path.
   * Ignore default.nix and non-regular files.
   */
  importAllFromPath = path:
    lib.attrsets.mapAttrsToList
      (name: _: (lib.path.append path "./${name}" ))
      (
        lib.attrsets.filterAttrs
          (name: type: (
            type == "regular"
            && (lib.strings.hasSuffix ".nix" name)
            && name != "default.nix"
          ))
          (builtins.readDir (builtins.toString path))
      );
}
