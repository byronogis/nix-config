{
  config,
  ctx,
  pkgs,
  ...
}:
{
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

  # The Home Manager gateway reads this file as the primary user.
  sops.secrets.hermes-agent-env = {
    owner = ctx.host.primaryUser;
    mode = "0400";
  };

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
