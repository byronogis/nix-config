{
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--color 16"
      "--cycle"
      "--layout reverse"
    ];
    fileWidget.options = [
      "--preview 'bat {} || cat {} | head -500'"
    ];
  };
}
