{
  services.openssh = {
    enable = true;
    settings = {
      # Don't Forbid root login through SSH? "yes"/"no"
      PermitRootLogin = "yes";
      # Don't Use keys only? true/false
      PasswordAuthentication = false;
    };
  };
}
