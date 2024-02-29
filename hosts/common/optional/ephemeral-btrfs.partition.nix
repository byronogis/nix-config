# power by disko
{ host, ... }: {
  size = "100%";
  content = {
    type = "btrfs";
    # TODO why --label or -L not take effect both ?
    extraArgs = [ "-f" "--label ${host.hostname}" ];
    subvolumes = {
      "@" = {
        mountpoint = "/";
        mountOptions = [ "compress=zstd" ];
      };
      "@blank" = {
        mountpoint = "/blank";
        mountOptions = [ "compress=zstd" ];
      };
      "@nix" = {
        mountpoint = "/nix";
        mountOptions = [ "compress=zstd" "noatime" ];
      };
      "@persist" = {
        mountpoint = "${host.persist}";
        mountOptions = [ "compress=zstd" ];
      };
      "@swap" = {
        mountpoint = "/swap";
        mountOptions = [ "noatime" ];
      };
    };
  };
}
