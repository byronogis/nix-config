{ lib
, host
, user
, ...
}: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      # See: https://docs.github.com/zh/authentication/troubleshooting-ssh/using-ssh-over-the-https-port
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
    };
  };
}
