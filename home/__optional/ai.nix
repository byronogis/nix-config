# See https://nix-community.github.io/home-manager/options.xhtml
{ inputs
, outputs
, host
, user
, pkgs
, lib
, ...
}: {
  home = {
    shellAliases = {
      # see https://docs.openwebui.com/#installation-with-uv-recommended
      ow = "DATA_DIR=~/.open-webui nix run nixpkgs#uv -- tool run --python 3.11 open-webui@latest serve";
    };

    packages = with pkgs; [
      ffmpeg
    ];
  };

  services = {
    ollama = {
      enable = true;
      environmentVariables = {
        # more can find by `ollama serve -h`
        OLLAMA_ORIGINS = "*";
      };
    };
  };
}
