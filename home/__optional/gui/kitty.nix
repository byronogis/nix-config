{ ... }: {
  programs.kitty = {
    enable = true;

    font = {
      name = "Hack Nerd Font";
      size = 14;
    };

    settings = {
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      macos_option_as_alt = true;
    };

    darwinLaunchOptions = [ "--start-as=maximized" ];
  };
}
