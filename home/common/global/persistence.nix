{ lib
, inputs
, host
, user
, ...
}: lib.optionalAttrs host.impermanence {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence = {
    "${host.persistencePath}/home/${user.username}" = {
      directories = [
        # ...
      ] ++ lib.optionals (user ? "persistence" ? "directories") user.persistence.directories;
      files = [
        # ...
      ] ++ lib.optionals (user ? "persistence" ? "files") user.persistence.files;
      allowOther = true;
    };
  };

}
