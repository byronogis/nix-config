{
  pkgs,
  inputs,
  devenvRoot ? null,
  ...
}:
let
  devenv = inputs.devenv;
  # Common devenv configuration with optional root
  mkDevenvShell =
    modules:
    devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ({
          # Set devenv root if provided
          devenv.root = devenvRoot;

          packages = with pkgs; [ zsh ];
          enterShell = ''
            zsh
          '';
        })
      ]
      ++ modules;
    };
in
{
  default = (import ../default.nix { inherit pkgs; }).default;

  hello = mkDevenvShell [
    {
      packages = with pkgs; [ hello ];
      enterShell = ''
        hello -g "You are now in a nix shell with hello!"
      '';
    }
  ];
  js = mkDevenvShell [ (import ./js.nix) ];
  python = mkDevenvShell [ (import ./python.nix) ];
  go = mkDevenvShell [ (import ./go.nix) ];
  # flutter = mkDevenvShell [ (import ./flutter.nix) ];
  rust = mkDevenvShell [ (import ./rust.nix) ];

  byron = mkDevenvShell [
    # I use fnm to manage node
    # (import ./js.nix)
    # (import ./python.nix)
    # (import ./go.nix)
  ];
}
