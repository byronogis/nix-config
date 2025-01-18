{ inputs
, lib
, pkgs
, config
, host
, ...
}: {
  # quicker for macos
  # https://www.yuque.com/quicker-community/help/intro
  environment.systemPackages = with pkgs; [
    # 1. exec `dotnet --info` to see the path,
    #    like /nix/store/32nfhchbbfqa5v77nfy4z8zjngf5frq0-dotnet-runtime-7.0.20/share/dotnet
    # 2. link the path to /usr/local/share/dotnet
    #    `sudo ln -s /nix/store/32nfhchbbfqa5v77nfy4z8zjngf5frq0-dotnet-runtime-7.0.20/share/dotnet /usr/local/share/dotnet`
    # 3. remove link when uninstall
    #    `sudo rm /usr/local/share/dotnet`
    dotnet-runtime_7
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-7.0.20"
  ];
}
