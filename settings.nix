{ lib }:
rec {
  userAttrs = {
    byron = {
      username = "byron";
      usernameAlternative = "byronogis";
      usernameFull = "Byron Ogis";
      useremail = "byronogis@outlook.com";
      initialPassword = "123456";
      sops.sshKeys = {
        rea = false;
        ed25519 = false;
      };
      persistence = {
        directories = [
          "projects"
          "Document"
          "Downloads"
          ".vscode-server"
          ".local/share/fnm"
          ".local/share/mise"
          ".local/share/direnv"
          ".local/share/containers"
          ".ssh"
        ];
        files = [
          ".zsh_history"
          ".npmrc"
          # ...
        ];
      }; # used by impermanence
      usernameKeyForGit = "usernameAlternative";
    };
  };

  # ==> [ "byron" ]
  usernames = builtins.attrNames userAttrs;

  hostAttrs = {
    mv-nixos = {
      hostname = "mv-nixos";
      os = "nixos";
      system = "aarch64-linux";
      device = "sda";
      impermanence = true;
      persistencePath = "/persist";
      sops.sshKeys = {
        rea = false;
        ed25519 = true;
      };
      userAttrs = {
        byron = userAttrs.byron // {
          sops.sshKeys = {
            rea = false;
            ed25519 = true;
          };
        };
      };
      primaryUser = "byron";
      allowedPorts = [ ];
      allowedPortRanges = [
        {
          from = 3000;
          to = 5999;
        }
      ];
    };

    Byrons-MacBook-Pro = {
      hostname = "Byrons-MacBook-Pro";
      os = "darwin";
      system = "aarch64-darwin";
      impermanence = false;
      sops.sshKeys = {
        rea = false;
        ed25519 = true;
      };
      userAttrs = {
        byron = userAttrs.byron // {
          sops.sshKeys = {
            rea = false;
            ed25519 = true;
          };
        };
      };
      primaryUser = "byron";
    };
  };

  # ==> [ "mydarwin" "mynixos" "mynixos2" ]
  hostnames = builtins.attrNames hostAttrs;

  # ==> [ { ... } { ... } { ... } ]
  hostvalues = builtins.attrValues hostAttrs;

  # ==> [ "x86_64-darwin" "x86_64-linux" ... ]
  systems = lib.lists.unique (lib.attrsets.mapAttrsToList (name: value: value.system) hostAttrs);

  # ==> { darwin = [ ... ]; nixos = [ ... ]; }
  osGroupAttrs = lib.lists.groupBy (hostvalue: hostvalue.os) hostvalues;
}
