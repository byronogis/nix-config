# AGENTS.md

Standing instructions for AI coding agents in this repository. Keep this file short: add rules only when they prevent repeated mistakes or protect risky workflows.

English | [中文](./AGENTS.zh-cn.md)

## Working Model

- This is a multi-user, multi-host Nix flake for NixOS and nix-darwin.
- `settings.nix` is the source of truth for users, hosts, systems, OS groups, persistence flags, `primaryUser`, and each host's enabled users.
- `flake.nix` builds `ctx` from `settings.nix`; modules should use `ctx`, not re-import `settings.nix`.
- Host modules use `ctx.host`. Home Manager per-user modules get `ctx.user` while iterating `ctx.host.userAttrs`.
- Shared behavior goes in `hosts/__global/` or `home/__global/`; opt-in behavior goes in `hosts/__optional/` or `home/__optional/`; machine-specific behavior goes in `hosts/<hostname>/`.

## Edit Rules

- Add users in `settings.nix:userAttrs` first, then add `home/<username>/`.
- Enable a user on a host through `settings.nix:hostAttrs.<hostname>.userAttrs`; do not assume every global user belongs on every host.
- Add hosts in `settings.nix:hostAttrs` first, then add `hosts/<hostname>/configuration.nix`.
- Do not hardcode dynamic repository data such as usernames, hostnames, systems, or enabled users; derive them from `ctx` or `settings.nix`, or use placeholders in documentation.
- Do not hardcode user lists when they can be derived from `ctx.host.userAttrs`.
- Prefer existing `outputs.lib._local` helpers over one-off logic.
- Keep modules declarative. Add activation scripts only for real boot/activation-time behavior.
- Keep optional services/packages opt-in; do not broaden imports globally when one host or user can import an optional module.

## High-Risk Areas

- Do not read, print, decrypt, copy, or rewrite SOPS secrets unless the user explicitly asks.
- SOPS files include `hosts/secrets.yaml` and `hosts/<hostname>/secrets.yaml`.
- Current SOPS age key paths come from enabled users' `~/.ssh/id_ed25519` and the host key at `/etc/ssh/ssh_host_ed25519_key`; impermanent hosts prefix the host key with `ctx.host.persistencePath`.
- Treat Disko, boot/initrd, btrfs subvolumes, filesystem labels, persistence roots, and `hardware-configuration.nix` as high risk. Explain verification steps.
- For impermanent NixOS hosts, persistent state is rooted at `ctx.host.persistencePath`; add paths through `outputs.lib._local.setHostPersistence` or existing `environment.persistence` patterns.
- Ephemeral btrfs rollback uses systemd initrd. Escape `-` as `\x2d` in systemd device unit names.

## Host Operations

- Treat `nixos-rebuild`, `darwin-rebuild`, `systemctl`, host `podman`, Disko, filesystem, boot/initrd, and disk commands as host operations.
- If you are in a container or remote agent shell, provide commands for the user to run on the target host unless host execution is explicitly available.
- Never run destructive host operations without explicit confirmation and a clear target.

## Commands

Parse touched Nix files:

```sh
nix-instantiate --parse <path>
```

Evaluate affected hosts:

```sh
nix eval .#nixosConfigurations.<hostname>.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.<hostname>.config.system.build.toplevel.drvPath
```

When evaluating changes that add new files, first add them to the Git index
(`git add -N <path>` is enough) or evaluate through `path:$PWD#...`; plain
`.#...` flake references ignore untracked files.

Format Nix when appropriate:

```sh
nix fmt
```

Check whitespace before finishing:

```sh
git diff --check
```

## Documentation

- `README.md` is English; `README.zh-cn.md` is Chinese. Keep them structurally aligned.
- `AGENTS.md` is English; `AGENTS.zh-cn.md` is Chinese. Keep them structurally aligned.
- Language navigation keeps the current language as plain text and links only the other language.
- In README commands, prefer placing `--flake .#<hostname>` at the end when supported.
- Do not turn AGENTS.md into a README clone. Link to docs or inspect the repo when information is discoverable.

## Git

- Do not revert user changes.
- Do not run `git reset`, `git clean`, rebase, force push, or broad checkout commands unless explicitly requested.
- Ignore unrelated dirty worktree changes. If user edits touch files you need, work with them.
- Commit only when asked; use concise conventional commit messages.
