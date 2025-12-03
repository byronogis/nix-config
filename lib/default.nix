{ lib, ... }: {
  /**
   * Batch import Nix modules from a directory path.
   *
   * Automatically filters and imports .nix files based on configurable patterns,
   * with support for recursive scanning and flexible include/exclude rules.
   *
   * @param path The directory path to scan for Nix modules
   * @param options Configuration options (all optional):
   *   - include: List of regex patterns for files to include (default: [".*\\.nix"])
   *   - exclude: List of regex patterns for files to exclude (default: [])
   *   - self: Filename of the caller to exclude (default: "default.nix")
   *   - recursive: Recursion depth control:
   *       * false/0: Only scan current directory (default)
   *       * 1,2,3...: Recurse to specified depth
   *       * true: Unlimited recursion depth
   *
   * @return List of absolute paths to matching Nix files
   *
   * Examples:
   *   import ./. { }                                    # Import all .nix files (except default.nix) from current dir
   *   import ./. { self = "custom.nix"; }              # Exclude custom.nix instead of default.nix
   *   import ./. { exclude = ["test-.*\\.nix"]; }      # Exclude test files
   *   import ./. { recursive = 1; }                    # Include direct subdirectories
   *   import ./. { recursive = true; }                 # Recursively scan all subdirectories
   *   import ./. { include = ["(foo|bar)\\.nix"]; }    # Only import foo.nix and bar.nix
   */
  import =
    let
      impl = path: { include ? [".*\\.nix"], exclude ? [], self ? "default.nix", recursive ? false, ... }:
        let
          # Check if a name matches any regex pattern in a list
          matchesAny = name: patterns:
            patterns != [] && builtins.any (pattern:
              lib.strings.match pattern name != null
            ) patterns;

          shouldInclude = name: type:
            type == "regular"
            && matchesAny name include
            && !(matchesAny name exclude)
            && name != self;

          # Get files from current directory
          currentDirFiles = lib.attrsets.mapAttrsToList
            (name: _: (lib.path.append path "./${name}"))
            (lib.attrsets.filterAttrs shouldInclude (builtins.readDir (builtins.toString path)));

          # Determine if we should recurse into subdirectories
          shouldRecurse =
            if builtins.isBool recursive then recursive
            else if builtins.isInt recursive then recursive > 0
            else false;

          # Calculate next recursion depth
          nextRecursive =
            if builtins.isBool recursive then recursive
            else if builtins.isInt recursive then recursive - 1
            else false;

          # Get files from subdirectories if recursive is enabled
          subdirFiles =
            if !shouldRecurse then []
            else
              let
                isDirectory = name: type: type == "directory";
                dirs = lib.attrsets.filterAttrs isDirectory (builtins.readDir (builtins.toString path));
              in
                lib.lists.flatten (lib.attrsets.mapAttrsToList
                  (name: _:
                    impl (lib.path.append path "./${name}") {
                      inherit include exclude;
                      recursive = nextRecursive;
                      self = ""; # Don't exclude default.nix in subdirectories
                    }
                  )
                  dirs
                );
        in
        currentDirFiles ++ subdirFiles;
    in
    impl;

  setHostPersistence = { host, settings, ... }:
    lib.optionalAttrs (host ? "impermanence" && host.impermanence) {
      environment.persistence."${host.persistencePath}" = settings;
    };

  /**
   * Make a cask with greedy option for homebrew
   * See https://github.com/nix-darwin/nix-darwin/issues/935
   */
  mkCaskGreedy = caskName: { name = caskName; greedy = true; };
}
