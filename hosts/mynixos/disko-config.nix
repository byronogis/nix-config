{ inputs
, host
, ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ../__optional/ephemeral-btrfs.nix
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
            Primary = import ../__optional/ephemeral-btrfs.partition.nix { inherit host; };
          };
        };
      };
    };
  };
}
