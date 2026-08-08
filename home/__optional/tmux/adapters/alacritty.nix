{
  lib,
  pkgs,
  ...
}:
let
  keybindings = import ../keybindings.nix { };

  keyNames = {
    left = "ArrowLeft";
    down = "ArrowDown";
    up = "ArrowUp";
    right = "ArrowRight";
    enter = "Enter";
  };

  modifierNames = {
    primary = "Command";
    secondary = "Option";
    extra = "Control";
    shift = "Shift";
  };

  toAlacrittyKey = key: keyNames.${key} or (lib.toUpper key);
  toAlacrittyMods =
    modifiers: lib.concatMapStringsSep "|" (modifier: modifierNames.${modifier}) modifiers;

  renderBinding = binding: {
    key = toAlacrittyKey binding.shortcut.key;
    mods = toAlacrittyMods binding.shortcut.modifiers;
    chars = "\\u${keybindings.prefixSequence}${binding.sequence}";
  };
in
{
  assertions = [
    {
      assertion = pkgs.stdenv.isDarwin;
      message = "The Alacritty tmux terminal adapter is only supported on macOS.";
    }
  ];

  programs.alacritty.settings.keyboard.bindings = map renderBinding keybindings.bindings;
}
