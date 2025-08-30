# My NixOS Setup

This is my personal NixOS configuration for a clean, keyboard-focused development machine. I built it to keep things simple, consistent, and distraction-free while coding.

https://github.com/user-attachments/assets/d45f3687-cfda-47a7-b2e9-3c0dbdb562bf

## What I Focus On

- **Minimal clutter**: Shell has no widgets and apps take the whole vertical space. Pressing `Super` reveals the overlay with the widgets.
- **Unified styling**: Consistent colors, fonts, and styles across:
  - System GTK/Qt themes and custom Neuwaita icon theme (merged with MoreWaita)
  - Terminal emulators (Kitty, Alacritty)
  - Text editors (VSCode, Helix, Zed)
  - Web browsers (Firefox with custom userstyles)
  - Window manager (Niri with custom color schemes)
  - Desktop shell (Astal with theme-aware widgets)
- **Reproducible**: Everything's declarative, so I can set it up the same way anywhere

## Software

### Main Components

- **[Niri](https://github.com/YaLTeR/niri)**: A modern, Wayland-native tiling window manager that provides efficient keyboard-driven window management. It supports custom layouts, workspaces, and seamless integration with the desktop environment for a distraction-free coding experience.
- **[Astal Shell](https://github.com/knoopx/astal-shell)**: A custom desktop shell built on Astal framework, featuring theme-aware widgets for system monitoring, notifications, and quick access to applications.
- **[Vicinae](https://github.com/vicinaehq/vicinae/)**: Application launcher inspired by Raycast
- **[Firefox](https://www.mozilla.org/firefox/)**: Web browser optimized for privacy with [uBlock Origin](https://github.com/gorhill/uBlock) for ad-blocking, custom search engines, and userstyles for consistent theming. Includes policies for enhanced security and performance thanks to [BetterFox](https://github.com/yokoffing/BetterFox)
- **[Kitty](https://github.com/kovidgoyal/kitty)**: GPU-accelerated terminal emulator
- **[Fish](https://github.com/fish-shell/fish-shell)**: The user-friendly command line shell.
- **[Hyprlock](https://github.com/hyprwm/Hyprlock)**: Screen locker with custom theme
- **[VSCode](https://github.com/microsoft/vscode)**: Primary code editor. Configured with custom keybindings, themes, and productivity tools for development

### Development Environments

The `modules/home-manager/packages/dev/` directory contains language-specific development environments, each providing essential tools for programming in that language:

- **[Crystal](https://github.com/crystal-lang/crystal)**: Compiler, [Crystalline](https://github.com/elbywan/crystalline) language server, [Shards](https://github.com/crystal-lang/shards) package manager, and [Mint framework](https://github.com/mint-lang/mint) for building web applications
- **[Go](https://github.com/golang/go)**: Compiler, [gopls](https://github.com/golang/tools/tree/master/gopls) language server, [Delve](https://github.com/go-delve/delve) debugger, and build tools for efficient Go development
- **JavaScript**: [Node.js](https://github.com/nodejs/node) runtime, package managers ([Yarn](https://github.com/yarnpkg/yarn), [pnpm](https://github.com/pnpm/pnpm)), [TypeScript](https://github.com/microsoft/TypeScript) compiler, and development utilities for modern web development
- **[Nix](https://github.com/NixOS/nix)**: [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt) formatter, linter, and [nixd](https://github.com/nix-community/nixd) language server for Nix language development and configuration
- **[Python](https://github.com/python/cpython)**: Interpreter, package managers ([pip](https://github.com/pypa/pip), [poetry](https://github.com/python-poetry/poetry)), virtual environment tools, and development utilities
- **[Ruby](https://github.com/ruby/ruby)**: Interpreter, [Bundler](https://github.com/rubygems/bundler) for dependency management, and development tools for Ruby applications
- **[Rust](https://github.com/rust-lang/rust)**: Compiler, [Cargo](https://github.com/rust-lang/cargo) package manager, and additional tools for Rust development
- **System**: C/C++ compilers ([GCC](https://gcc.gnu.org/), [Clang](https://clang.llvm.org/)), build tools, and system-level development utilities

## How It's Organized

### My Machines

- **desktop/**: Main workstation featuring:
  - NVIDIA graphics with CUDA support
  - [BTRFS](https://btrfs.readthedocs.io/en/latest/) filesystem with advanced features
  - Container services ([Watchtower](https://github.com/containrrr/watchtower) for updates)
  - Hardware acceleration for AI models
- **minibook/**: Chuwi Minibook X N150 laptop configuration:
  - Hardware-specific drivers and optimizations
  - Power management and battery optimizations
- **vm/**: Virtual machine setup for testing
- **live-usb/**: Bootable USB configuration for system recovery and installation

### Modules

- **modules/nixos/**: System-level configurations including:
  - **defaults/**: Global settings for AI, colors, display, fonts, system, and user
  - **services/**: System services ([Plex Media Server](https://www.plex.tv/), [Traefik](https://github.com/traefik/traefik), Android backup, [auto-scrcpy](https://github.com/robinmordasiewicz/auto-scrcpy), etc.)
  - **system/**: Core system settings (boot, networking, hardware, packages)
  - **theming/**: [Stylix](https://github.com/danth/stylix) theming configuration
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
  - Custom builds for [Glance](https://github.com/glanceapp/glance), [Geary](https://gitlab.gnome.org/GNOME/geary), [Zed Editor](https://github.com/zed-industries/zed), [RetroArch](https://github.com/libretro/RetroArch), etc.
  - Theme and UI modifications
- **builders/**: Helper functions for creating package derivations
- **lib/**: Utility functions for theming, color manipulation, and module loading
- **pkgs/**: Custom package definitions ([Neuwaita Icon Theme](https://github.com/knoopx/neuwaita-icon-theme), [MoreWaita Icon Theme](https://github.com/somepaulo/MoreWaita), [Llama Swap](https://github.com/knoopx/llama-swap), [Vicinae](https://github.com/vicinaehq/vicinae), etc.)
- **flake.nix**: Main flake with inputs, outputs, and system configurations
- **flake.lock**: Dependency lock file for reproducible builds
