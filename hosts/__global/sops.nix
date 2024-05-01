{ inputs, lib, config, host, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;

    secrets = lib.attrsets.concatMapAttrs
      (username: user: {
        "${username}-password" = {
          neededForUsers = true;
        };
        "${username}-github-access-token" = { };
      })
      host.userAttrs;
  };
}
