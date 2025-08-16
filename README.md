https://github.com/user-attachments/assets/d45f3687-cfda-47a7-b2e9-3c0dbdb562bf

# Description

A comprehensive NixOS configuration designed for a clutter-free, keyboard-driven development workstation. This configuration emphasizes a unified experience across all applications with consistent theming, efficient workflows, and minimal visual distractions.

## Philosophy

This configuration prioritizes:

- **Keyboard-driven workflow**: Minimal mouse dependency with efficient key bindings
- **Unified theming**: Consistent visual experience across all applications and popular websites via Stylix and Firefox userstyles
- **Clutter-free interface**: Clean, minimal aesthetics with hidden decorations where possible
- **Development-focused**: Optimized for coding with modern tools and workflows
- **Reproducible environments**: Fully declarative configuration for consistent setups

## Desktop Features

### Window Management & Navigation

- **Niri**: Columnar tiling layout with keyboard-driven workflow and smart window rules
- **[Astal Shell](https://github.com/knoopx/astal-shell)**: Modern desktop shell with widgets and system integration

### Applications & Tools

- **VSCode**: Comprehensive development environment with language servers and AI integration
- **Firefox**: Privacy-focused browser with uBlock Origin and custom search engines
- **Kitty**: GPU-accelerated terminal with Fish shell and intelligent completions
- **Nautilus**: File manager with quick preview capabilities
- **Glance**: Self-hosted dashboard for weather, calendar, news feeds, and monitoring
- [**Vibeapps**](https://github.com/knoopx/vibeapps/): A collection of keyboard-centric, minimalist GTK4/Adwaita micro-applications built with Python, including:
  - **Launcher**: Minimalist application launcher with search functionality and launch history tracking
  - **Notes**: Markdown note-taking application with wiki-links support and live preview
  - **Chat**: OpenAI API chat interface with markdown rendering support and streaming responses
  - **Bookmarks**: Fast Firefox bookmarks browser with search functionality and keyboard navigation
  - **Music**: Minimalist music player with library management and queue functionality
  - **Scratchpad**: Interactive calculator similar to Soulver for mathematical computations
  - **Nix Packages**: Simple interface to query and browse Nix packages

## Configuration Structure

### Host Configurations

- **desktop/**: My primary development workstation with NVIDIA GPU, BTRFS storage, and container services
- **minibook/**: My Chuwi Minibook X N150 configuration.
- **vm/**: Virtual machine configuration for testing and demos

### Modular Architecture

- **modules/nixos/**: System-level NixOS modules (services, hardware, networking)
- **modules/home-manager/**: User-space configurations (applications, dotfiles, desktop environment)
- **overlays/**: Custom package modifications and additions
- **builders/**: Functions that create derivations
