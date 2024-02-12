# This file (and the global directory) holds config that i use on all hosts
{ inputs, outputs, host, ... }: {
  imports = [
    ./editor.nix
    ./home.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./optin-persistence.nix
    ./systemd-initrd.nix
    ./users.nix
    ./zsh.nix
  ];

  networking.hostName = host.hostname;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  services.fstrim.enable = true;
}
