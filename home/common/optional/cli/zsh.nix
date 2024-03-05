{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      history = {
        ignoreAllDups = true;
      };
      historySubstringSearch = {
        enable = true;
        searchDownKey = [ "$terminfo[kcud1]" ];
        searchUpKey = [ "$terminfo[kcuu1]" ];
      };
      shellAliases = {
        check = "nix flake check --show-trace";
        update = "sudo nixos-rebuild switch --show-trace --flake ";
        sp = "set_proxy";
      };
      initExtra = ''
        # NOTE Fixme fnm can not completions postinstall
        eval "$(fnm env --use-on-cd)"

        # Define a function to set or unset proxy
        set_proxy() {
          local proxy_url="$1"

          # Check if proxy_url is empty
          if [ -z "$proxy_url" ]; then
            # Unset HTTP proxy
            unset http_proxy
            unset HTTP_PROXY

            # Unset HTTPS proxy
            unset https_proxy
            unset HTTPS_PROXY

            echo "Proxy unset"
          else
            # Set HTTP proxy
            export http_proxy="$proxy_url"
            export HTTP_PROXY="$proxy_url"

            # Set HTTPS proxy
            export https_proxy="$proxy_url"
            export HTTPS_PROXY="$proxy_url"

            echo "Proxy set to: $proxy_url"
          fi
        }
      '';
    };
  };
}
