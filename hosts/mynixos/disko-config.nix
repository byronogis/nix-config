{ inputs, host, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      "${host.device}" = {
        type = "disk";
        device = "/dev/${host.device}";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              start = "1M";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            Primary = import ../common/optional/ephemeral-btrfs.partition.nix { inherit host; };
          };
        };
      };
    };
  };
}
