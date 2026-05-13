# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
#
# It works even if / is tmpfs, btrfs snapshot, or even not ephemeral at all.
{
  inputs,
  config,
  outputs,
  ctx,
  ...
}:
outputs.lib.optionalAttrs ctx.host.impermanence {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence = {
    "${ctx.host.persistencePath}" = {
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
        "/etc/ssh/ssh_host_ecdsa_key"
        "/etc/ssh/ssh_host_ecdsa_key.pub"
      ];
      users = builtins.mapAttrs (
        username: user:
        (outputs.lib.recursiveUpdate {
          directories = [ ];
          files = [
            ".local/share/nix/trusted-settings.json"
          ];
        } user.persistence)
      ) ctx.host.userAttrs;
    };
  };
  programs.fuse.userAllowOther = true;
  fileSystems."${ctx.host.persistencePath}".neededForBoot = true;

  system.activationScripts.persistent-dirs.text =
    let
      mkHomePersist =
        user:
        outputs.lib.optionalString user.createHome ''
          mkdir -p ${ctx.host.persistencePath}/${user.home}
          chown ${user.name}:${user.group} ${ctx.host.persistencePath}/${user.home}
          chmod ${user.homeMode} ${ctx.host.persistencePath}/${user.home}
        '';
      users = outputs.lib.attrValues config.users.users;
    in
    outputs.lib.concatLines (map mkHomePersist users);
}
