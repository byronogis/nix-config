{ outputs, ... }:
{
  # See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  time.timeZone = outputs.lib.mkDefault "Asia/Shanghai";
}
