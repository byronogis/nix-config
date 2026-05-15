{
  keyOverrides ? { },
}:
let
  # 默认键名表。下面的 bindings 不直接写散落的字符串，而是通过 keys.<name> 引用；
  # 未来某个终端适配器如果需要不同的键名，可以在 import 时传入 keyOverrides 覆盖。
  defaultKeys = {
    a = "a";
    b = "b";
    c = "c";
    d = "d";
    e = "e";
    f = "f";
    g = "g";
    h = "h";
    i = "i";
    j = "j";
    k = "k";
    l = "l";
    m = "m";
    n = "n";
    o = "o";
    p = "p";
    q = "q";
    r = "r";
    s = "s";
    t = "t";
    u = "u";
    v = "v";
    w = "w";
    x = "x";
    y = "y";
    z = "z";

    "1" = "1";
    "2" = "2";
    "3" = "3";
    "4" = "4";
    "5" = "5";
    "6" = "6";
    "7" = "7";
    "8" = "8";
    "9" = "9";

    "[" = "[";
    "]" = "]";
    left = "left";
    down = "down";
    up = "up";
    right = "right";
    enter = "enter";
  };

  keys = defaultKeys // keyOverrides;
in
{
  inherit keys;

  # tmux 前缀键。适配器会把下面的 sequence 渲染成 “prefix + sequence”。
  prefix = "C-a";

  # 终端模拟器无关的快捷键表：
  # - action: 逻辑动作名，方便搜索和未来给其它适配器复用。
  # - shortcut: 用户感知的快捷键，用通用名称描述，不使用某个终端的键名。
  # - sequence: 发送给 tmux 的前缀后按键；例如 "c" 表示 C-a c。
  # - description: 面向人的功能说明。
  bindings = [
    {
      action = "new-window";
      shortcut = {
        key = keys.t;
        modifiers = [ "command" ];
      };
      sequence = "c";
      description = "新建 tmux window";
    }
    {
      action = "previous-window";
      shortcut = {
        key = keys."[";
        modifiers = [
          "command"
          "shift"
        ];
      };
      sequence = "p";
      description = "切换到上一个 tmux window";
    }
    {
      action = "next-window";
      shortcut = {
        key = keys."]";
        modifiers = [
          "command"
          "shift"
        ];
      };
      sequence = "n";
      description = "切换到下一个 tmux window";
    }
    {
      action = "split-horizontal";
      shortcut = {
        key = keys.d;
        modifiers = [ "command" ];
      };
      # 对应 tmux 配置中的 bind | split-window -h -c '#{pane_current_path}'。
      sequence = "|";
      description = "左右分屏";
    }
    {
      action = "split-vertical";
      shortcut = {
        key = keys.d;
        modifiers = [
          "command"
          "shift"
        ];
      };
      # 对应 tmux 配置中的 bind - split-window -v -c '#{pane_current_path}'。
      sequence = "-";
      description = "上下分屏";
    }
    {
      action = "pane-left";
      shortcut = {
        key = keys.left;
        modifiers = [
          "command"
          "option"
        ];
      };
      sequence = "h";
      description = "切换到左侧 pane";
    }
    {
      action = "pane-down";
      shortcut = {
        key = keys.down;
        modifiers = [
          "command"
          "option"
        ];
      };
      sequence = "j";
      description = "切换到下方 pane";
    }
    {
      action = "pane-up";
      shortcut = {
        key = keys.up;
        modifiers = [
          "command"
          "option"
        ];
      };
      sequence = "k";
      description = "切换到上方 pane";
    }
    {
      action = "pane-right";
      shortcut = {
        key = keys.right;
        modifiers = [
          "command"
          "option"
        ];
      };
      sequence = "l";
      description = "切换到右侧 pane";
    }
    {
      action = "toggle-pane-zoom";
      shortcut = {
        key = keys.enter;
        modifiers = [
          "command"
          "shift"
        ];
      };
      sequence = "z";
      description = "放大或恢复当前 pane";
    }
    {
      action = "resize-pane-left";
      shortcut = {
        key = keys.left;
        modifiers = [
          "command"
          "control"
        ];
      };
      sequence = "H";
      description = "向左缩小当前 pane 宽度";
    }
    {
      action = "resize-pane-down";
      shortcut = {
        key = keys.down;
        modifiers = [
          "command"
          "control"
        ];
      };
      sequence = "J";
      description = "向下增大当前 pane 高度";
    }
    {
      action = "resize-pane-up";
      shortcut = {
        key = keys.up;
        modifiers = [
          "command"
          "control"
        ];
      };
      sequence = "K";
      description = "向上缩小当前 pane 高度";
    }
    {
      action = "resize-pane-right";
      shortcut = {
        key = keys.right;
        modifiers = [
          "command"
          "control"
        ];
      };
      sequence = "L";
      description = "向右增大当前 pane 宽度";
    }
    {
      action = "close-pane";
      shortcut = {
        key = keys.w;
        modifiers = [ "command" ];
      };
      sequence = "x";
      description = "关闭当前 pane";
    }
    {
      action = "close-window";
      shortcut = {
        key = keys.w;
        modifiers = [
          "command"
          "shift"
        ];
      };
      sequence = "&";
      description = "关闭当前 window";
    }
    {
      action = "detach-session";
      shortcut = {
        key = keys.e;
        modifiers = [ "command" ];
      };
      # 对应 tmux 默认 bind d detach-client；保留当前 session 和布局。
      sequence = "d";
      description = "断开当前 tmux session，保留会话状态";
    }
    {
      action = "kill-session";
      shortcut = {
        key = keys.e;
        modifiers = [
          "command"
          "shift"
        ];
      };
      # 对应 tmux 配置中的 bind e kill-session。
      sequence = "e";
      description = "清理当前 tmux session 并回到外层 shell";
    }
  ]
  # Cmd+1 到 Cmd+9 切换 tmux window 1 到 9。
  ++ builtins.genList (
    index:
    let
      window = builtins.toString (index + 1);
    in
    {
      action = "select-window-${window}";
      shortcut = {
        key = keys.${window};
        modifiers = [ "command" ];
      };
      sequence = window;
      description = "切换到 tmux window ${window}";
    }
  ) 9;
}
