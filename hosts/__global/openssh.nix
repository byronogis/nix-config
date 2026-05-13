{
  outputs,
  config,
  ctx,
  ...
}:
let
  pubKey = hostname: ./../${hostname}/ssh_host_ed25519_key.pub;
in
{
  programs.ssh = {
    # Each hosts public key
    knownHosts = builtins.mapAttrs (hostname: _: {
      publicKeyFile = pubKey hostname;
      extraHostNames = outputs.lib.optional (hostname == ctx.host.hostname) "localhost"; # Alias for localhost if it's the same host
    }) (outputs.nixosConfigurations // outputs.darwinConfigurations);
  };

  services.openssh =
    if ctx.host.os == "nixos" then
      {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "yes";
        };
        hostKeys =
          [ ]
          ++ outputs.lib.optionals (!outputs.lib._local.hasSopsSshKeys "rsa" ctx.host) [
            {
              bits = 4096;
              path = "${outputs.lib.optionalString ctx.host.impermanence ctx.host.persistencePath}/etc/ssh/ssh_host_rsa_key";
              type = "rsa";
            }
          ]
          ++ outputs.lib.optionals (!outputs.lib._local.hasSopsSshKeys "ed25519" ctx.host) [
            {
              path = "${outputs.lib.optionalString ctx.host.impermanence ctx.host.persistencePath}/etc/ssh/ssh_host_ed25519_key";
              type = "ed25519";
            }
          ];
      }
    else
      { };
}
