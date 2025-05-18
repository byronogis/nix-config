{ host
, lib
, config
, pkgs
, ...
}: {
  system = {
    # transition mechanism
    # see https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.primaryUser
    primaryUser = host.primaryUser;

    # TODO `system.activationScripts.postUserActivation` option has been removed
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    # activationScripts = {
    #   postUserActivation.text = ''
    #     # reload the settings and apply them without the need to logout/login
    #     /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    #   '';
    # };

    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;
  };
}
