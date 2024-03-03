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
    };
  };
}
