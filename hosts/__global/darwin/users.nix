{ host
, lib
, config
, pkgs
, ...
}: {
  users = {
    users =
      builtins.mapAttrs
        (
          username: user: {
            home = "/Users/${username}";
          }
        )
        host.userAttrs;
  };
}
