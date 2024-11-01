{ inputs
, config
, lib
, host
, ...
}: {
  imports = [
    ../__optional/wsl.nix
    ../__optional/nix-ld.nix
    # ../__optional/v2raya.nix
    # ../__optional/zerotierone.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "24.05";
}
