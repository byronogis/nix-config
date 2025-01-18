{ config
, lib
, pkgs
, ...
}: {
  imports = [
    # ...
    ./homebrew.nix
    ./system-defaults.nix
    ./quicker.nix
  ];

  environment.systemPackages = with pkgs; [
    scrcpy
    cocoapods
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
