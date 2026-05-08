{
  inputs,
  ctx,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ../__optional/ephemeral-btrfs.nix
  ];

  disko.devices = {
    disk = {
      "${ctx.host.device}" = {
        type = "disk";
        device = "/dev/${ctx.host.device}";
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
            Primary = import ../__optional/ephemeral-btrfs.partition.nix { inherit ctx; };
          };
        };
      };
    };
  };
}
