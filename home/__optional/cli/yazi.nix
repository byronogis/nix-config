# https://yazi-rs.github.io/docs/quick-start

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
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
    keymap = {
      input.prepend_keymap = [
        {
          on = "<Esc>";
          run = "close";
          desc = "Close input by once Esc press";
        }
      ];
    };
    initLua = ''
      -- Show user/group of files in status bar
      Status:children_add(function()
        local h = cx.active.current.hovered
        if not h or ya.target_family() ~= "unix" then
          return ""
        end

        return ui.Line {
          ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
          ":",
          ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
          " ",
        }
      end, 500, Status.RIGHT)
    '';
  };
}
