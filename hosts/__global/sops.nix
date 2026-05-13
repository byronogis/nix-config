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

  user-secrets = outputs.lib.attrsets.concatMapAttrs (username: user: {
    "${username}:password" = {
      # neededForUsers cannot be used for secrets that are not root-owned
      neededForUsers = true;
    };
    "${username}:github-access-token" = { };
    "${username}:zerotierone-net" = { };
  }) ctx.host.userAttrs;
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
