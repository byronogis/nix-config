{ pkgs, inputs, ... }:
let
  devenv = inputs.devenv;
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
}
