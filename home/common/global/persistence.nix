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
      ] ++ lib.optionals (lib.hasAttrByPath [ "persistence" "directories" ] user) user.persistence.directories;
      files = [
        # ...
      ] ++ lib.optionals (lib.hasAttrByPath [ "persistence" "files" ] user) user.persistence.files;
      allowOther = true;
    };
  };

}
