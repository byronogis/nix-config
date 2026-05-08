{ outputs, config, ... }:

let
  mkFontOption = kind: {
    family = outputs.lib.mkOption {
      type = outputs.lib.types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };
    package = outputs.lib.mkOption {
      type = outputs.lib.types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
  };
  cfg = config.fontProfiles;
in
{
  options.fontProfiles = {
    enable = outputs.lib.mkEnableOption "Whether to enable font profiles";
    monospace = mkFontOption "monospace";
    regular = mkFontOption "regular";
  };

  config = outputs.lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      cfg.monospace.package
      cfg.regular.package
    ];
  };
}
