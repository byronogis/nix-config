{ lib
, host
, user
, ...
}: lib.recursiveUpdate
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}
  (lib.optionalAttrs host.impermanence {
    home.persistence."${host.persistencePath}/home/${user.username}" = {
      directories = [
        ".local/share/direnv"
      ];
    };
  })
