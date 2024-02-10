{ lib }:

rec {
  userAttrs = {
    byron = {
      username = "byron";
      useremail = "byronogsi@outlook.com";
      initialPassword = "123456";
    };
  };

  # ==> [ "byron" ]
  usernames = builtins.attrNames userAttrs;

  hostAttrs = {
    mynixos = {
      hostname = "mynixos";
      os = "nixos";
      system = "x86_64-linux";
      userAttrs = {
        inherit (userAttrs) byron;
      };
    };
    # mynixos2 = {
    #   hostname = "mynixos2";
    #   os = "nixos";
    #   system = "x86_64-linux";
    #   userAttrs = {
    #     inherit (userAttrs) byron;
    #   };
    # };
    # mydarwin = {
    #   hostname = "mydarwin";
    #   os = "darwin";
    #   system = "x86_64-darwin";
    #   userAttrs = {
    #     inherit (userAttrs) byron;
    #   };
    # };
  };

  # ==> [ "mydarwin" "mynixos" "mynixos2" ]
  hostnames = builtins.attrNames hostAttrs;

  # ==> [ { ... } { ... } { ... } ]
  hostvalues = builtins.attrValues hostAttrs;

  # ==> [ "x86_64-darwin" "x86_64-linux" ]
  systems = lib.lists.unique (
    lib.attrsets.mapAttrsToList (
      name: value: value.system
    ) hostAttrs
  );

  # ==> { darwin = [ ... ]; nixos = [ ... ]; }
  osGroupAttrs = lib.lists.groupBy (hostvalue: hostvalue.os ) hostvalues;
}
