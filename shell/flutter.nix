{ pkgs, lib, ... }: {
  # languages.dart = {
  #   enable = true;
  # };
  android = {
    enable = true;
    # flutter.enable = true;
  };
  languages.java.jdk.package = lib.mkForce pkgs.jdk17;
  stdenv = pkgs.stdenvNoCC;
}
