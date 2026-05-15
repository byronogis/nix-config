{
  # see https://github.com/nix-community/home-manager/blob/master/modules/programs/tmux.nix
  programs.tmux = {
    enable = true;

    # 这些选项会生成多行或结构性配置，用 Home Manager 声明更清晰。
    baseIndex = 1;
    keyMode = "vi";
    # Kaku 适配器当前通过 string.char(1) 发送 C-a；修改这里时需要同步适配器。
    prefix = "C-a";
    terminal = "tmux-256color";

    extraConfig = ''
      # 交互默认值：鼠标支持、24 小时时钟、更大的滚动历史，
      # 以及更好的缩放和焦点事件处理。
      set -g mouse on
      set -g focus-events on
      setw -g aggressive-resize on
      setw -g clock-mode-style 24
      set -g history-limit 50000

      # 关闭窗口后自动整理编号，增强剪贴板集成，并在 tmux 内保留 truecolor。
      set -g renumber-windows on
      set -g set-clipboard on
      set -as terminal-overrides ',*:RGB'
      setw -g automatic-rename off

      # 不引入主题插件，只做最小化的状态栏和 pane 边框样式。
      set -g status-interval 5
      set -g status-left-length 30
      set -g status-left '#[fg=colour16 bg=colour81 bold] #S #[default]#{?client_prefix,#[fg=colour16 bg=colour214 bold] PREFIX #[default] ,}#{?pane_in_mode,#[fg=colour16 bg=colour214 bold] COPY #[default] , }'
      set -g status-right '#[fg=colour244]#(~/.config/tmux/status-right.sh) #[fg=colour81]%H:%M'
      set -g status-style 'bg=default,fg=colour244'
      set -g window-status-format '#I:#{b:pane_current_path}'
      set -g window-status-current-format '#{?window_zoomed_flag,#[fg=colour16 bg=colour214 bold] ZOOM #[default] ,}#I:#{pane_current_path}'
      set -g window-status-current-style 'fg=colour81,bold'
      set -g pane-border-style 'fg=colour238'
      set -g pane-active-border-style 'fg=colour81'

      # 新窗口和分屏继承当前 pane 的工作目录。
      bind r source-file ~/.config/tmux/tmux.conf \; display-message 'tmux config reloaded'
      bind c new-window -c '#{pane_current_path}'
      bind | split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'

      # Vim 风格 pane 导航。
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Vim 风格 pane 大小调整。
      bind H resize-pane -L 5
      bind J resize-pane -D 5
      bind K resize-pane -U 5
      bind L resize-pane -R 5

      # 会话管理：d 沿用 tmux 默认 detach，e 确认后清理当前 session。
      bind e confirm-before -y -p 'kill session #S? (Y/n)' kill-session

      # 关闭 pane/window 时不二次确认。
      bind x kill-pane
      bind & kill-window

      # Vim 风格复制选择：v 开始选择，y 复制并退出。
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
    '';
  };

  home.shellAliases = {
    t = "tmux new -A -s main";
  };

  xdg.configFile."tmux/status-right.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh

      os="$(uname -s)"

      cpu_usage() {
        case "$os" in
          Darwin)
            top -l 1 -n 0 | awk -F'[:,% ]+' '/CPU usage/ { printf "%d%%", $3 + $5 + 0.5; exit }'
            ;;
          Linux)
            top -bn1 | awk -F'[, ]+' '/Cpu\(s\)|%Cpu/ {
              for (i = 1; i <= NF; i++) {
                if ($i == "id") {
                  printf "%d%%", 100 - $(i - 1) + 0.5
                  exit
                }
              }
            }'
            ;;
          *)
            printf "n/a"
            ;;
        esac
      }

      mem_usage() {
        case "$os" in
          Darwin)
            total="$(sysctl -n hw.memsize 2>/dev/null)"
            page_size="$(pagesize 2>/dev/null)"
            vm_stat | awk -v total="$total" -v page_size="$page_size" '
              /Pages active/ { active = $3 }
              /Pages wired down/ { wired = $4 }
              /Pages occupied by compressor/ { compressed = $5 }
              END {
                gsub(/\./, "", active)
                gsub(/\./, "", wired)
                gsub(/\./, "", compressed)
                if (total > 0 && page_size > 0) {
                  printf "%d%%", ((active + wired + compressed) * page_size / total * 100) + 0.5
                } else {
                  printf "n/a"
                }
              }'
            ;;
          Linux)
            free | awk '/Mem:/ { printf "%d%%", ($3 / $2 * 100) + 0.5; exit }'
            ;;
          *)
            printf "n/a"
            ;;
        esac
      }

      disk_usage() {
        df -h "$HOME" | awk 'NR == 2 { print $5 }'
      }

      printf "CPU %s MEM %s DISK %s" "$(cpu_usage)" "$(mem_usage)" "$(disk_usage)"
    '';
  };
}
