{ lib
, pkgs
, host
, user
, ...
}: {
  programs.mise = {
    enable = true;
    globalConfig = {
      settings = {
        status = {
          show_env = true;
          show_tools = true;
          truncate = false;
        };
      };
    };
  };

}
