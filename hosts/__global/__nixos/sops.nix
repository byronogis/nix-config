# edit secret file:
# sudo SOPS_AGE_KEY_FILE=/run/secrets.d/age-keys.txt sops ./hosts/secrets.yaml
# see: https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-age

{ inputs, lib, config, host, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets.yaml;

    secrets =
      let
        user-secrets = lib.attrsets.concatMapAttrs
          (username: user: {
            "${username}-password" = {
              # neededForUsers cannot be used for secrets that are not root-owned
              neededForUsers = true;
            };
            "${username}-github-access-token" = { };
            "${username}-zerotierone-net" = { };
          })
          host.userAttrs;
      in
      {
        nix-extra-access-tokens = { };
      } // user-secrets;
  };
}
