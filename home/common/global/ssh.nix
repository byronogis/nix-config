{ lib
, host
, user
, ...
}: lib.recursiveUpdate
{ }
  (lib.optionalAttrs host.impermanence {
    home.persistence."${host.persistencePath}/home/${user.username}" = {
      directories = [
        ".ssh"
      ];
    };
  })
