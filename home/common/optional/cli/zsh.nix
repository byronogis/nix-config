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
      shellAliases = {
        check = "nix flake check --show-trace";
        update = "sudo nixos-rebuild switch --show-trace --flake ";
      };
      initExtra = ''
        # Search history on up and down keys according input.
        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey "$key[Up]" up-line-or-beginning-search
        bindkey "$key[Down]" down-line-or-beginning-search

        # Fix fnm can not completions postinstall
        eval "$(fnm env --use-on-cd)"
      '';
    };
  };
}
