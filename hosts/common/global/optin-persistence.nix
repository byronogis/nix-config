# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
#
# It works even if / is tmpfs, btrfs snapshot, or even not ephemeral at all.
{ inputs, config, lib, host, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence = {
    "${host.persist}" = {
      directories = [
        "/var/lib/systemd"
        "/var/lib/nixos"
        "/var/log"
        "/srv"
      ];
      users = builtins.mapAttrs (
        name: value: value.persistence
      ) host.userAttrs;
    };
  };
  programs.fuse.userAllowOther = true;
  fileSystems."${host.persist}".neededForBoot = true;

  system.activationScripts.persistent-dirs.text =
    let
      mkHomePersist = user: lib.optionalString user.createHome ''
        mkdir -p ${host.persist}/${user.home}
        chown ${user.name}:${user.group} ${host.persist}/${user.home}
        chmod ${user.homeMode} ${host.persist}/${user.home}
      '';
      users = lib.attrValues config.users.users;
    in
    lib.concatLines (map mkHomePersist users);
}
