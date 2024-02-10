{ lib, ... }: {
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };
  # See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  time.timeZone = lib.mkDefault "Asia/Shanghai";
}
