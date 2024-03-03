# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
#
# It works even if / is tmpfs, btrfs snapshot, or even not ephemeral at all.
{ inputs
, config
, lib
, host
, ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence = {
    "${host.persistencePath}" = {
      directories = [
        "/var/lib/systemd"
        "/var/lib/nixos"
        "/var/log"
        "/srv"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
      users =
        builtins.mapAttrs
          (
            name: value: value.persistence
          )
          host.userAttrs;
    };
  };
  programs.fuse.userAllowOther = true;
  fileSystems."${host.persistencePath}".neededForBoot = true;

  system.activationScripts.persistent-dirs.text =
    let
      mkHomePersist = user:
        lib.optionalString user.createHome ''
          mkdir -p ${host.persistencePath}/${user.home}
          chown ${user.name}:${user.group} ${host.persistencePath}/${user.home}
          chmod ${user.homeMode} ${host.persistencePath}/${user.home}
        '';
      users = lib.attrValues config.users.users;
    in
    lib.concatLines (map mkHomePersist users);
}
