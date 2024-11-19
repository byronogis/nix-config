{ lib }: rec {
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
          "Document"
          "Downloads"
          ".vscode-server"
          ".local/share/fnm"
          ".local/share/direnv"
          ".local/share/containers"
          ".ssh"
        ];
        files = [
          ".zsh_history"
          # ...
        ];
      }; # used by impermanence
      usernameKeyForGit = "usernameAlternative";
    };
  };

  # ==> [ "byron" ]
  usernames = builtins.attrNames userAttrs;

  hostAttrs = {
    itx-nixos = {
      hostname = "itx-nixos";
      os = "nixos";
      system = "x86_64-linux";
      device = "sda";
      impermanence = true;
      persistencePath = "/persist";
      userAttrs = {
        inherit (userAttrs) byron;
      };
      allowedPorts = [ ];
      allowedPortRanges = [
        { from = 3000; to = 5999; }
      ];
    };

    Byrons-MacBook-Pro = {
      hostname = "Byrons-MacBook-Pro";
      os = "darwin";
      system = "aarch64-darwin";
      userAttrs = {
        inherit (userAttrs) byron;
      };
    };

    h14air-nixos = {
      hostname = "h14air-nixos";
      os = "nixos";
      system = "x86_64-linux";
      device = "sda";
      impermanence = false;
      persistencePath = "/persist";
      userAttrs = {
        inherit (userAttrs) byron;
      };
    };
  };

  # ==> [ "mydarwin" "mynixos" "mynixos2" ]
  hostnames = builtins.attrNames hostAttrs;

  # ==> [ { ... } { ... } { ... } ]
  hostvalues = builtins.attrValues hostAttrs;

  # ==> [ "x86_64-darwin" "x86_64-linux" ... ]
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
