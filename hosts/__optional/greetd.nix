# See https://man.sr.ht/~kennylevinsen/greetd/

{ ... }: {
  services.greetd = {
    enable = true;
    settings = {
      # initial_session = {
      #   command = "";
      #   user = "";
      # };
      # default_session = {
      #   command = "${pkgs.sway}/bin/sway";
      # };
    };
  };

  programs.regreet = {
    enable = true;
  };
}
