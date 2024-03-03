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
        bindkey "''${key[Up]}" up-line-or-search
        bindkey "$key[Down]" down-line-or-search
      '';
    };
  };
}
