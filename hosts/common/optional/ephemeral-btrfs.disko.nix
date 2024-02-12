{ lib, config, host, ... }: {
  disko.devices = {
    disk = {
      "${host.device}" = {
        type = "disk";
        device = "/dev/${host.device}";
        content = {
          type = "gpt";
          partitions = {
            Primary = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "--label ${host.hostname}" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" ];
                  };
                  "@swap" = {
                    mountpoint = "/swap";
                    mountOptions = [ "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
}
