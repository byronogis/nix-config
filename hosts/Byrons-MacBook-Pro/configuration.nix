{ config
, lib
, pkgs
, ...
}: {
  imports = [
    # ...
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}