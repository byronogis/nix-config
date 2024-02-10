{
  self,
  inputs,
  outputs,
  constants,
  forAllSystems,
  # lib,
  # config,
  # pkgs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;

  specialArgsForSystem = system:
    {
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
    } // inputs;

  allSystemSpecialArgs = forAllSystems (system: specialArgsForSystem);

  args = lib.attrsets.mergeAttrsList [
    inputs
    outputs
    constants
    { inherit self lib allSystemSpecialArgs; }
  ];
in 
  # imports = [
  #   ./nixos.nix
  # ];
  lib.attrsets.mergeAttrsList [
    (import ./nixos.nix args)
  ]

