{ outputs, ctx, ... }:
{
  imports = [ ] ++ outputs.lib._local.import ./. { };

  home = {
    homeDirectory = "/home/${ctx.user.username}";
  };
}
