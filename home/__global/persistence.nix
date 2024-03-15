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
      ] ++ (lib.attrByPath [ "persistence" "directories" ] [ ] user);
      files = [
        # ...
      ] ++ (lib.attrByPath [ "persistence" "files" ] [ ] user);
      allowOther = true;
    };
  };

}
