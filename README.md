https://github.com/user-attachments/assets/d45f3687-cfda-47a7-b2e9-3c0dbdb562bf

# My NixOS Setup

This is my personal NixOS configuration for a clean, keyboard-focused development machine. I built it to keep things simple, consistent, and distraction-free while coding.

## What I Focus On

- **Minimal clutter**: Shell has no widgets and apps take the whole vertical space. Pressing `Super` reveals the overlay with the widgets.
- **Unified styling**: Consistent colors, fonts, and styles across:
  - System GTK/Qt themes
  - Terminal emulators (Kitty, Alacritty)
  - Text editors (VSCode, Helix, Zed)
  - Web browsers (Firefox with custom userstyles)
  - Window manager (Niri with custom color schemes)
  - Desktop shell (Astal with theme-aware widgets)
- **Reproducible**: Everything's declarative, so I can set it up the same way anywhere

## Software

### Main Components

- **Niri**: A modern, Wayland-native tiling window manager that provides efficient keyboard-driven window management. It supports custom layouts, workspaces, and seamless integration with the desktop environment for a distraction-free coding experience.
- **[Astal Shell](https://github.com/knoopx/astal-shell)**: A custom desktop shell built on Astal framework, featuring theme-aware widgets for system monitoring, notifications, and quick access to applications. It maintains a minimal overlay design that appears on `Super` key press.
- **Firefox**: Web browser optimized for privacy with uBlock Origin for ad-blocking, custom search engines, and userstyles for consistent theming. Includes policies for enhanced security and performance.
- **Kitty**: GPU-accelerated terminal emulator running Fish shell with smart autocompletions, syntax highlighting, and custom themes. Provides fast rendering and extensive customization for command-line work.
- **Fish**: Interactive shell with advanced autocompletions, syntax highlighting, and custom functions for efficient command-line usage.
- **Hyprlock**: Screen locker with custom themes and animations for secure session management.
- **Nautilus**: GNOME's file manager with enhanced preview capabilities, custom desktop integration, and keyboard shortcuts for efficient file navigation and management.
- **VSCode**: Primary code editor with extensive language support, debugging capabilities, and AI-assisted coding through extensions. Configured with custom keybindings, themes, and productivity tools for development workflows.

### Development Environments

The `modules/home-manager/packages/dev/` directory contains language-specific development environments, each providing essential tools for programming in that language:

- **Crystal**: Compiler, language server (Crystalline), package manager (Shards), and Mint framework for building web applications
- **Go**: Compiler, language server (gopls), debugger (Delve), and build tools for efficient Go development
- **JavaScript**: Node.js runtime, package managers (Yarn, pnpm), TypeScript compiler, and development utilities for modern web development
- **Nix**: Formatter (nixpkgs-fmt), linter, and language server (nixd) for Nix language development and configuration
- **Python**: Interpreter, package managers (pip, poetry), virtual environment tools, and development utilities
- **Ruby**: Interpreter, bundler for dependency management, and development tools for Ruby applications
- **Rust**: Compiler, Cargo package manager, and additional tools for Rust development
- **System**: C/C++ compilers (GCC, Clang), build tools, and system-level development utilities

## How It's Organized

### My Machines

- **desktop/**: Main workstation featuring:
  - NVIDIA graphics with CUDA support
  - BTRFS filesystem with advanced features
  - Container services (Watchtower for updates)
  - Hardware acceleration for AI models
- **minibook/**: Chuwi Minibook X N150 laptop configuration:
  - Hardware-specific drivers and optimizations
  - Power management and battery optimizations
- **vm/**: Virtual machine setup for testing
- **live-usb/**: Bootable USB configuration for system recovery and installation

### Modules

- **modules/nixos/**: System-level configurations including:
  - **defaults/**: Global settings for AI, colors, display, fonts, system, and user
  - **services/**: System services (Plex, Traefik, Android backup, auto-scrcpy, etc.)
  - **system/**: Core system settings (boot, networking, hardware, packages)
  - **theming/**: Stylix theming configuration
  - **wm/**: Window manager and desktop environment settings
- **modules/home-manager/**: User environment configurations:
  - **packages/**: User packages and development tools
    - **dev/**: Language-specific development environments
    - **cli.nix**: Command-line interface utilities
    - **gtk.nix**: GTK-related packages
  - **programs/**: Application configurations (VSCode, Firefox, Kitty, etc.)
  - **services/**: User services and daemons
  - **wm/**: Window manager user settings
  - **environment/**: User environment variables and session settings
- **overlays/**: Package customizations and fixes:
  - Custom builds for Glance, Geary, Zed Editor, RetroArch, etc.
  - Theme and UI modifications
- **builders/**: Helper functions for creating package derivations
- **lib/**: Utility functions for theming, color manipulation, and module loading
- **pkgs/**: Custom package definitions (Neuwaita icons, Llama swap, Vicinae, etc.)
- **flake.nix**: Main flake with inputs, outputs, and system configurations
- **flake.lock**: Dependency lock file for reproducible builds
