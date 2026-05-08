{ outputs, ... }:
{
  i18n = {
    defaultLocale = outputs.lib.mkDefault "en_US.UTF-8";
    supportedLocales = outputs.lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };
}
