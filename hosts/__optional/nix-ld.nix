{ inputs
, pkgs
, ...
}: {
  programs.nix-ld.enable = true;
  programs.nix-ld.package = inputs.nix-ld-rs.packages.${pkgs.hostPlatform.system}.nix-ld-rs;
}
