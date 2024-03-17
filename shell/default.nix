{ pkgs, inputs, ... }:
let
  devenv = inputs.devenv;
  defineDev = modules: devenv.lib.mkShell { inherit inputs pkgs modules; };
in
{
  hello = devenv.lib.mkShell {
    inherit inputs pkgs;
    modules = [
      {
        packages = with pkgs; [ hello ];
        enterShell = ''
          hello -g "You are now in a nix shell with hello!"
        '';
      }
    ];
  };
  js = defineDev [
    ./js.nix
  ];
  python = defineDev [
    ./python.nix
  ];
  go = defineDev [
    ./go.nix
  ];
}
