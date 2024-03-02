{
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--color 16"
      "--cycle"
      "--layout reverse"
    ];
    fileWidgetOptions = [
       "--preview 'bat {} || cat {} | head -500'"
    ];
  };
}
