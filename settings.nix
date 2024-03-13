{ lib }: rec {
  userAttrs = {
    byron = {
      username = "byron";
      usernameAlternative = "byronogis";
      usernameFull = "Byron Ogis";
      useremail = "byronogis@outlook.com";
      # initialPassword = "123456";
      persistence = {
        directories = [
          "project"
          ".vscode-server"
        ];
        files = [
          # ...
        ];
      }; # used by impermanence
      usernameKeyForGit = "usernameAlternative";
    };
  };

  # ==> [ "byron" ]
  usernames = builtins.attrNames userAttrs;

  hostAttrs = {
    mynixos = {
      hostname = "mynixos";
      os = "nixos";
      system = "x86_64-linux";
      device = "sda"; # used by disko 
      impermanence = true; # whether to use impermanence
      persistencePath = "/persist"; # used by impermanence, absolute path
      userAttrs = {
        inherit (userAttrs) byron;
      };
      allowedPorts = [ ]; # used by firewall
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
    lib.attrsets.mapAttrsToList
      (
        name: value: value.system
      )
      hostAttrs
  );

  # ==> { darwin = [ ... ]; nixos = [ ... ]; }
  osGroupAttrs = lib.lists.groupBy (hostvalue: hostvalue.os) hostvalues;
}
