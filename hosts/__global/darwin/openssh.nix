# TODO see https://github.com/LnL7/nix-darwin/issues/627
{ outputs
, lib
, config
, host
, ...
}:
let
  pubKey = hostname: ./../${hostname}/ssh_host_ed25519_key.pub;
in
{
  programs.ssh = {
    # Each hosts public key
    knownHosts =
      builtins.mapAttrs
        (hostname: _: {
          publicKeyFile = pubKey hostname;
          extraHostNames =
            lib.optional
              (
                hostname == host.hostname
              )
              "localhost"; # Alias for localhost if it's the same host
        })
        outputs.darwinConfigurations;
  };
}
