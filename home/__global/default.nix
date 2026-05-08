{ outputs, ctx, ... }:
{
  imports =
    [ ] ++ outputs.lib._local.import ./. { } ++ (builtins.attrValues outputs.homeManagerModules);

  home = {
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
  };
}
