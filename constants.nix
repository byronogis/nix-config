{
  username = "byron";
  useremail = "byronogsi@outlook.com";
  initialPassword = "123456";

  hosts = {
    nixos = [
      "mynixos"
    ];
  };

  # Supported systems for your flake packages, shell, etc.
  systems = [
    # "aarch64-linux"
    # "i686-linux"
    "x86_64-linux"
    # "aarch64-darwin"
    # "x86_64-darwin"
  ];
}
