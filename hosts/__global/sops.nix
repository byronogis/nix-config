# edit secret file:
# sudo SOPS_AGE_KEY_FILE=/run/secrets.d/age-keys.txt sops ./hosts/secrets.yaml
# see: https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-age

{
  inputs,
  outputs,
  config,
  ctx,
  ...
}:
let
  sopsModulesByOS = {
    nixos = inputs.sops-nix.nixosModules.sops;
    darwin = inputs.sops-nix.darwinModules.sops;
  };
  sopsModule =
    sopsModulesByOS.${ctx.host.os} or (throw "Unsupported host os for sops module: ${ctx.host.os}");

  getUserKeyPath = type: username: "${config.users.users.${username}.home}/.ssh/id_${type}";
  getHostKeyPath =
    type:
    "${outputs.lib.optionalString ctx.host.impermanence ctx.host.persistencePath}/etc/ssh/ssh_host_${type}_key";

  user-secrets = outputs.lib.attrsets.concatMapAttrs (
    username: user:
    {
      "${username}:password" = {
        # neededForUsers cannot be used for secrets that are not root-owned
        neededForUsers = true;
      };
      "${username}:github-access-token" = { };
      "${username}:zerotierone-net" = { };

    }
    // outputs.lib.optionalAttrs (outputs.lib._local.hasSopsSshKeys "ed25519" user) {
      "${username}_at_${ctx.host.hostname}:ssh-ed25519" = {
        mode = "0600";
        owner = config.users.users.${username}.name;
        path = getUserKeyPath "ed25519" username;
      };
      "${username}_at_${ctx.host.hostname}:ssh-ed25519.pub" = {
        mode = "0644";
        owner = config.users.users.${username}.name;
        path = "${getUserKeyPath "ed25519" username}.pub";
      };
    }
  ) ctx.host.userAttrs;
in
{
  imports = [
    sopsModule
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;

    secrets = {
      nix-extra-access-tokens = { };
    }
    // outputs.lib.optionalAttrs (outputs.lib._local.hasSopsSshKeys "ed25519" ctx.host) {
      "host_at_${ctx.host.hostname}:ssh-ed25519" = {
        mode = "0600";
        path = getHostKeyPath "ed25519";
      };
      "host_at_${ctx.host.hostname}:ssh-ed25519.pub" = {
        mode = "0644";
        path = "${getHostKeyPath "ed25519"}.pub";
      };
    }
    // user-secrets;

    age = {
      sshKeyPaths =
        builtins.map (username: getUserKeyPath "ed25519" username) (builtins.attrNames ctx.host.userAttrs)
        ++ [
          "${getHostKeyPath "ed25519"}"
        ];
    };
  };

  environment.variables = {
    SOPS_AGE_KEY_FILE = "/run/secrets.d/age-keys.txt";
  };
}
