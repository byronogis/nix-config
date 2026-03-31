{ config
, pkgs
, ...
}: {
  programs.alacritty = {
    enable = true;
    # https://alacritty.org/config-alacritty.html
    settings = {
      terminal = {
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          args = [ "--login" "-c" "zellij" ];
        };
      };

      font = {
        normal.family = config.fontProfiles.monospace.family;
        size = 14.0;
      };

      selection = {
        save_to_clipboard = true;
      };

      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };

      window = {
        startup_mode = "Windowed";
        option_as_alt = "Both";
      };
    };
  };
}
