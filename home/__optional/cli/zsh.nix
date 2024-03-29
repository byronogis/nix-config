# See https://zsh.sourceforge.io/Doc/Release/Options.html
{ lib
, pkgs
, host
, user
, ...
}: lib.recursiveUpdate
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      history = {
        save = 10000;
        size = 10000;
        expireDuplicatesFirst = true;
        extended = true;
        ignoreAllDups = true;
        ignoreDups = true;
        ignoreSpace = true;
      };
      historySubstringSearch = {
        enable = true;
        searchDownKey = [ "$terminfo[kcud1]" ];
        searchUpKey = [ "$terminfo[kcuu1]" ];
      };
      shellAliases = {
        SP = "set_proxy";
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

  (lib.optionalAttrs host.impermanence {
    home.persistence."${host.persistencePath}/home/${user.username}" = {
      files = [
        ".zsh_history"
      ];
    };
  })
