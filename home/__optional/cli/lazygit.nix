{...} : {
  programs.lazygit = {
    enable = true;
    settings = {
      update = {
        method = "never";
      };
    };
  };
}
