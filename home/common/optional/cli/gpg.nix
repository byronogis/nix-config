{ lib
, pkgs
, config
, host
, user
, ...
}:
let
  userPublicKeyPath = ../../../${user.username}/gpg.asc;
  pinentry =
    if config.gtk.enable then {
      packages = [ pkgs.pinentry-gnome pkgs.gcr ];
      name = "gnome3";
    } else {
      packages = [ pkgs.pinentry-curses ];
      name = "curses";
    };
in

lib.recursiveUpdate
{
  home.packages = pinentry.packages;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = pinentry.name;
    enableSshSupport = true;
    enableExtraSocket = true;
    defaultCacheTtl = 604800;
    maxCacheTtl = 604800;
  };

  programs.gpg = {
    enable = true;
    settings = { };
    publicKeys = [ ] ++ lib.optionals (builtins.pathExists userPublicKeyPath) [{
      source = userPublicKeyPath;
      trust = 5;
    }];
  };

}
  (lib.optionalAttrs host.impermanence {
    home.persistence."${host.persistencePath}/home/${user.username}" = {
      directories = [
        ".gnupg"
      ];
    };
  })
