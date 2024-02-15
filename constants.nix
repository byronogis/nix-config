{ lib }:

rec {
  userAttrs = {
    byron = {
      username = "byron";
      usernameAlternative = "byronogis";
      usernameFull = "Byron Ogis";
      useremail = "byronogis@outlook.com";
      initialPassword = "123456";
      persistence = {
        directories = [
          "project"
          ".ssh"
        ];
        files = [
          ".zsh_history"
        ];
      };
    };
  };

  # ==> [ "byron" ]
  usernames = builtins.attrNames userAttrs;

  hostAttrs = {
    mynixos = {
      hostname = "mynixos";
      os = "nixos";
      system = "x86_64-linux";
      device = "sda";
      persist = "/persist"; # absolute path
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
