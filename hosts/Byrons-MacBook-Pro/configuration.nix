{ config
, lib
, pkgs
, ...
}: {
  imports = [
    # ...
    ./homebrew.nix
    ./system-defaults.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
