{ lib, pkgs, config, ... }:
let
  cat = "${pkgs.coreutils}/bin/cat";
  cut = "${pkgs.coreutils}/bin/cut";
  find = "${pkgs.findutils}/bin/find";
  grep = "${pkgs.gnugrep}/bin/grep";
  pgrep = "${pkgs.procps}/bin/pgrep";
  tail = "${pkgs.coreutils}/bin/tail";
  wc = "${pkgs.coreutils}/bin/wc";
  xargs = "${pkgs.findutils}/bin/xargs";
  timeout = "${pkgs.coreutils}/bin/timeout";
  ping = "${pkgs.iputils}/bin/ping";

  systemctl = "${pkgs.systemd}/bin/systemctl";
  journalctl = "${pkgs.systemd}/bin/journalctl";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";

  hasHyprland = config.wayland.windowManager.hyprland.enable;
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    # @see https://github.com/Alexays/Waybar/wiki/Configuration
    settings = {
      primary = {
        name = "primary";
        mode = "dock";
        layer = "top";
        position = "top";
        height = 30;
        margin = "4";
        spacing = 4;
        modules-left = [
        ] ++ (lib.optionals hasHyprland [
          "hyprland/workspaces"
          "hyprland/submap"
          "hyprland/language"
        ]);
        modules-center = [
          "cpu"
          "custom/gpu"
          "memory"
          "clock"
          "pulseaudio"
          "battery"
        ];
        modules-right = [
          "network"
          "custom/hostname"
        ];

        # Modules
        clock = {
          interval = 1;
          format = "{:%d/%m %H:%M:%S}";
          format-alt = "{:%Y-%m-%d %H:%M:%S %z}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';

          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "left";
            format = {
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };

          actions = {
            on-click-left = "mode";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };
        cpu = {
          format = "  {usage}%";
        };
        memory = {
          format = "  {}%";
          interval = 5;
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [ "" "" "" ];
          };
          on-click = pavucontrol; # need pkgs.pavucontrol
        };
        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };
        network = {
          interval = 3;
          format-wifi = "   {essid}";
          format-ethernet = "󰈁 Connected";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };

        # Custom Modules
        "custom/gpu" = {
          interval = 5;
          exec = "${cat} /sys/class/drm/card0/device/gpu_busy_percent";
          format = "󰒋  {}%";
        };
        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
          on-click = "${systemctl} --user restart waybar";
        };
      };
    };
    style = ''
      * {
        font-size: 12pt;
        padding: 0;
        margin: 0 0.5em;
      }
      window#waybar {
        opacity: 0.75;
        border-radius: 0.5em;
      }
      .modules-left {
        margin-left: -0.65em;
      }
      .modules-right {
        margin-right: -0.65em;
      }
    '';
  };

  systemd.user.services.waybar = {
    Unit.StartLimitBurst = 30;
  };
}
