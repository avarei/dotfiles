# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Nix Flakes-based dotfiles managing system configurations across NixOS, macOS (nix-darwin), and standalone home-manager environments. Uses home-manager, nix-darwin, Stylix (theming), and nvf (Neovim configuration).

**Note:** All options are unstable and may change without notice.

## Common Commands

```sh
# Validate configuration
nix flake check

# Rebuild systems
sudo nixos-rebuild switch --flake .#desktop   # NixOS Desktop
sudo nixos-rebuild switch --flake .#server    # NixOS Server
darwin-rebuild switch --flake .#macbook       # macOS
home-manager switch --flake .#tim@work        # Home-manager only
```

## Architecture

### Directory Structure
- `flake.nix` - Main entry point defining inputs and all system configurations
- `hosts/` - Host-specific hardware configs (desktop.nix, server.nix)
- `modules/home/` - User-level configs (editor, shell, gui, git, kubernetes)
- `modules/nixos/` - NixOS-specific modules (gaming, selfhosted services)
- `modules/darwin/` - macOS-specific modules
- `modules/shared/` - Cross-platform configs (stylix theming)
- `templates/` - Flake templates for bootstrapping new systems

### Module Pattern

All modules follow a consistent opt-in pattern:

```nix
options.dotfiles.<category>.<name>.enable = lib.mkEnableOption "<description>";
config = lib.mkIf cfg.enable {
  # Configuration only applied when enabled
};
```

Modules are enabled hierarchically (e.g., `dotfiles.gui.enable` must be true for `dotfiles.gui.niri.enable` to work).

### Key Technologies
- **Niri**: Wayland compositor (not X11) for desktop GUI
- **Stylix**: Catppuccin Mocha theme applied automatically across all applications
- **nvf**: Declarative Neovim configuration (supports Nix, Go, Python, YAML, Markdown, Helm)
- **nushell/zsh**: Primary shells with starship prompt

### Flake Outputs
- `darwinConfigurations.macbook` - macOS system
- `nixosConfigurations.{desktop,server}` - NixOS systems
- `homeConfigurations."tim@work"` - Standalone home-manager
- `{home,nixos,darwin}Modules.default` - Reusable modules for downstream users
