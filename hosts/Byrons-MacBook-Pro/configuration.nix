{ config
, lib
, pkgs
, ...
}: {
  imports = [
    # ...
    ./homebrew.nix
    ./system-defaults.nix
    # ./quicker.nix
  ];

  environment.systemPackages = with pkgs; [
    scrcpy
    cocoapods
  ];

  environment.variables = {
    PATH = [
      "/opt/podman/bin" # From podman-desktop cask
      "$PATH"
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
