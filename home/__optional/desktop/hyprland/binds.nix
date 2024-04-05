{ lib, config, ... }: {
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "$MOD,mouse:272,movewindow"
      "$MOD,mouse:273,resizewindow"
    ];
    bind =
      let
        workspaces = [ ]
          ++ [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" ]
          ++ [ "F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10" "F11" "F12" ];
        # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
        directions = rec {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
        };
      in
      [
        "$MOD_SHIFT,q,killactive"
        "$MOD_SHIFT,backspace,exec,${config.home.sessionVariables.__WM_LOGOUT_DIALOGUE}"

        "$MOD,s,togglesplit" # dwindle layout
        "$MOD,f,fullscreen,1"
        "$MOD_SHIFT,f,fullscreen,0"
        "$MOD_SHIFT,space,togglefloating"

        "$MOD,g,togglegroup"
        "$MOD,t,lockactivegroup,toggle"
        "$MOD,tab,changegroupactive,f"
        "$MOD_SHIFT,tab,changegroupactive,b"

        "$MOD,minus,splitratio,-0.25"
        "$MOD,equal,splitratio,0.25"

        "$MOD,bracketleft,workspace,e-1"
        "$MOD,bracketright,workspace,e+1"

        "$MOD,backslash,togglespecialworkspace"
        "$MOD_SHIFT,backslash,movetoworkspacesilent,special"

        "$MOD,Return,exec,${config.home.sessionVariables.__WM_TERMINAL}"
        "$MOD,x,exec,${config.home.sessionVariables.__WM_LAUNCHER}"
      ]

      # Change workspace
      ++ (map (n: "$MOD,${n},workspace,name:${n}") workspaces)

      # Move window to workspace
      ++ (map (n: "$MOD_SHIFT,${n},movetoworkspacesilent,name:${n}") workspaces)

      # Move focus
      ++ (lib.mapAttrsToList (key: direction: "$MOD,${key},movefocus,${direction}") directions)

      # Swap windows
      ++ (lib.mapAttrsToList (key: direction: "$MOD_SHIFT,${key},swapwindow,${direction}") directions)
    ;
  };
}
