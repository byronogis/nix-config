{ outputs, ctx, ... }:
{
  imports = [ ] ++ outputs.lib._local.import ./. { };

  home = {
    homeDirectory = "/Users/${ctx.user.username}";
  };
}
