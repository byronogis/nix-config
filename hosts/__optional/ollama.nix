{ lib
, config
, host
, localLib
, ...
}:
let
  persistence = localLib.setHostPersistence {
    inherit host;
    settings = {
      directories = [
        "/var/lib/private/ollama"
      ];
    };
  };
in
{
  imports = [
    persistence
  ];

  services.ollama = {
    enable = true;
    # acceleration = "rocm";
  };
}
