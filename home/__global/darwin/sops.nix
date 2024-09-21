# edit secret file:
# sudo SOPS_AGE_KEY_FILE=/run/secrets.d/age-keys.txt sops ./hosts/secrets.yaml
# see: https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-age

{ inputs, lib, config, host, user, ... }: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../hosts/secrets.yaml;

    secrets =
      let
        user-secrets = {
          "${user.username}-github-access-token" = { };
        };
      in
      {
        nix-extra-access-tokens = { };
      } // user-secrets;

    age = {
      sshKeyPaths = [
        "/User/${user.username}/.ssh/id_ed25519"
      ];
    };
  };
}