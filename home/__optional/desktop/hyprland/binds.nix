{ config, ... }: {
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];
    bind =
      let
        workspaces = [ ] ++
          [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" ] ++
          [ "F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10" "F11" "F12" ];
      in
      [
        "SUPER,Return,exec,${config.home.sessionVariables.TERMINAL}"
      ] ++
      # Change workspace
      (map
        (n:
          "SUPER,${n},workspace,name:${n}"
        )
        workspaces) ++
      # Move window to workspace
      (map
        (n:
          "SUPERSHIFT,${n},movetoworkspacesilent,name:${n}"
        )
        workspaces);
  };
}
