{ lib
, pkgs
, host
, user
, ...
}: lib.recursiveUpdate
{
  home.packages = [ pkgs.fnm ];
  home.sessionVariables = {
    FNM_COREPACK_ENABLED = "true";
  };

}
  (lib.optionalAttrs host.impermanence {
    home.persistence."${host.persistencePath}/home/${user.username}" = {
      directories = [
        ".local/share/fnm"
      ];
    };
  })
