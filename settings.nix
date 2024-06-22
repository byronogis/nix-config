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
          ".vscode-server"
          ".local/share/fnm"
          ".local/share/direnv"
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
        { from = 5173; to = 5179; }
      ];
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
