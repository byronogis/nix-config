# https://yazi-rs.github.io/docs/quick-start

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      mgr = {
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
      };
      priview = {
        tab_size = 2;
      };
    };
  };
}
