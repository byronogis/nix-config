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

  services.openssh = {
    enable = true;
    extraConfig = ''
      # Allow password authentication for all users, including root
      PasswordAuthentication yes
      PermitRootLogin yes
    '';
    hostKeys = [
      {
        bits = 4096;
        path = "${outputs.lib.optionalString ctx.host.impermanence ctx.host.persistencePath}/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${outputs.lib.optionalString ctx.host.impermanence ctx.host.persistencePath}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        bits = 521;
        path = "${outputs.lib.optionalString ctx.host.impermanence ctx.host.persistencePath}/etc/ssh/ssh_host_ecdsa_key";
        type = "ecdsa";
      }
    ];
  };
}
