{
  ctx,
  config,
  pkgs,
  ...
}:
{
  users = {
    users = builtins.mapAttrs (username: user: {
      home = "/Users/${username}";
    }) ctx.host.userAttrs;
  };
}
