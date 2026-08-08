{
  config,
  lib,
  ...
}:
let
  tmux = lib.getExe config.programs.tmux.package;
  zsh = lib.getExe config.programs.zsh.package;
in
{
  programs.alacritty = {
    enable = true;
    # https://alacritty.org/config-alacritty.html
    settings = {
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
        dimensions = {
          columns = 170;
          lines = 48;
        };
      };

      terminal.shell = {
        program = zsh;
        args = [
          "-lc"
          "${tmux} new -A -s main; exec ${zsh} -l"
        ];
      };
    };
  };
}
