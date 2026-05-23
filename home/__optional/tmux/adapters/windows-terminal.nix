{
  config,
  lib,
  pkgs,
  ...
}:
let
  keybindings = import ../keybindings.nix { };

  modifierNames = {
    # Windows Terminal has no Command key. Treat the shared Command layer as Ctrl,
    # Option as Alt, and the shared Control layer as Shift for pane resizing.
    command = "ctrl";
    control = "shift";
    option = "alt";
    shift = "shift";
  };

  toWindowsTerminalKeys =
    shortcut:
    lib.concatStringsSep "+" (
      (lib.lists.unique (map (modifier: modifierNames.${modifier}) shortcut.modifiers))
      ++ [ shortcut.key ]
    );

  escapeJsonFragment = value: lib.escape [ "\\" "\"" ] value;

  renderAction =
    binding:
    let
      sequence = escapeJsonFragment binding.sequence;
    in
    ''
          {
            "command": {
              "action": "sendInput",
              "input": "\u0001${sequence}"
            },
            "id": ${builtins.toJSON "User.Tmux.${binding.action}"},
            "name": ${builtins.toJSON "tmux: ${binding.description}"}
          }'';

  renderKeybinding =
    binding:
    ''
          {
            "id": ${builtins.toJSON "User.Tmux.${binding.action}"},
            "keys": ${builtins.toJSON (toWindowsTerminalKeys binding.shortcut)}
          }'';

  fragmentText = ''
    {
      "$schema": "https://aka.ms/terminal-profiles-schema",
      "actions": [
    ${lib.concatStringsSep ",\n" (map renderAction keybindings.bindings)}
      ],
      "keybindings": [
    ${lib.concatStringsSep ",\n" (map renderKeybinding keybindings.bindings)}
      ]
    }
  '';
  fragmentFile = pkgs.writeText "windows-terminal-tmux-keybindings.json" fragmentText;
  windowsTerminalLocalState = "/mnt/c/Users/${config.home.username}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState";
  windowsSettingsFile = "${windowsTerminalLocalState}/settings.json";
  windowsTerminalFragments = "/mnt/c/Users/${config.home.username}/AppData/Local/Microsoft/Windows Terminal/Fragments/NixTmux";
  windowsFragmentFile = "${windowsTerminalFragments}/tmux-keybindings.json";
  jq = lib.getExe pkgs.jq;
in
{
  xdg.configFile."windows-terminal/tmux-keybindings.json".text = fragmentText;

  # Windows Terminal 1.24 discovers the action definitions from the Fragments
  # tree, but did not apply keybindings from that fragment in this setup. Keep
  # the generated fragment as the source of truth, then sync only User.Tmux.*
  # keybindings into settings.json. Revisit this after Windows Terminal updates:
  # if fragment keybindings become supported, the settings.json merge can go away.
  home.activation.installWindowsTerminalTmuxKeybindings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "/mnt/c/Users/${config.home.username}/AppData/Local/Microsoft/Windows Terminal" ]; then
      tmpFragment="${windowsFragmentFile}.$$"
      $DRY_RUN_CMD mkdir -p "${windowsTerminalFragments}"
      $DRY_RUN_CMD cp ${fragmentFile} "$tmpFragment"
      $DRY_RUN_CMD mv -f "$tmpFragment" "${windowsFragmentFile}"
    fi

    if [ -f "${windowsSettingsFile}" ]; then
      tmpSettings="${windowsSettingsFile}.$$"
      $DRY_RUN_CMD ${jq} --slurp '
        .[0] as $settings | .[1] as $fragment |
        $settings
        | .keybindings = (
            ((.keybindings // []) | map(select((.id | type != "string") or ((.id | startswith("User.Tmux.")) | not))))
            + ($fragment.keybindings // [])
          )
      ' "${windowsSettingsFile}" "${windowsFragmentFile}" > "$tmpSettings"
      $DRY_RUN_CMD mv -f "$tmpSettings" "${windowsSettingsFile}"
    fi
  '';
}
