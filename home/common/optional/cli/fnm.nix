{ pkgs, ... }: {
  home.packages = [ pkgs.fnm ];
  home.sessionVariables = {
    FNM_COREPACK_ENABLED = "true";
  };
}
