{ lib
, pkgs
, config
, host
, user
, ...
}:
let
  pgpPublicKeyFile = ../../${user.username}/pgp-public-key.asc;
in

{
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSshSupport = true;
    enableExtraSocket = true;
    defaultCacheTtl = 604800;
    maxCacheTtl = 604800;
  };

  programs.gpg = {
    enable = true;
    settings = { };
    publicKeys = [ ] ++ lib.optionals (builtins.pathExists pgpPublicKeyFile) [{
      source = pgpPublicKeyFile;
      trust = 5;
    }];
  };

}
