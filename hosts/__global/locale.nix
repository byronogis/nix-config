{ lib, ... }: {
  # See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  time.timeZone = lib.mkDefault "Asia/Shanghai";
}
