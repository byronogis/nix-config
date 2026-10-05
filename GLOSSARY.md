# Nix Configuration

This context names the repository-specific concepts used to compose host and user configurations.

## Language

**tmux terminal adapter**:
A terminal-specific Home Manager module that translates the shared tmux keybinding model into that terminal's native keybinding configuration. It does not own shell startup or automatically enter a tmux session.
_Avoid_: tmux adapter, terminal integration
