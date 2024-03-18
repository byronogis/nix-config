{
  programs = {
    starship = {
      enable = true;
      settings = {
        format = ''$all'';
        username = {
          show_always = true;
          format = "[$user]($style)";
        };
        hostname = {
          ssh_only = false;
          format = "@[$hostname]($style) ";
        };
        shlvl = {
          format = "[$shlvl]($style)^ ";
          threshold = 2;
          repeat = true;
          disabled = false;
        };
        directory = {
          truncation_length = 5;
          truncation_symbol = "…/";
          truncate_to_repo = true;
        };
      };
    };
  };
}
