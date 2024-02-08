# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  imports = [
    ../shared/experimental-features.nix
    # ../shared/home.nix
    ../shared/substituters.nix

    ./boot.nix
    ./fstrim.nix
    ./i18n.nix
    ./networking.nix
    ./nix-command-consistent.nix
    ./ssh.nix
    ./time.nix
  ]
}
