{ lib
, pkgs
, host
, user
, ...
}: {
  home.packages = [ pkgs.fnm ];
  home.sessionVariables = {
    FNM_COREPACK_ENABLED = "true";
    FNM_VERSION_FILE_STRATEGY = "recursive";
  };

}
