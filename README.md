# kOS

This is my personal NixOS configuration for a clean, keyboard-focused development machine. I built it to keep things simple, consistent, and distraction-free while coding.

https://github.com/user-attachments/assets/d45f3687-cfda-47a7-b2e9-3c0dbdb562bf

## Quick Start

```bash
# Run the VM demo
nix run github:knoopx/nix

# Or clone and run locally
git clone https://github.com/knoopx/nix
cd nix
nix run path:.
```

## Installation

The unattended installer creates a bootable ISO that automatically installs kOS to the first available disk.

```bash
# Build the installer ISO
nix build .#installer-iso

# Write it to a USB drive:
caligula burn result/iso/*.iso

# Or test in a VM first
nix run .#installer-vm-test
```

**Warning**: The installer automatically erases and partitions the first unused disk it finds. Use with caution.

## What I Focus On

- **Minimal clutter**: Shell has no widgets and apps take the whole vertical space. Keyboard-driven workflow throughout.
- **Unified styling**: Consistent colors, fonts, and styles across:
  - System GTK/Qt themes and custom Neuwaita icon theme (merged with MoreWaita)
  - Terminal emulator (Kitty)
  - Text editors (VSCode, Helix)
  - Window manager (Niri with custom color schemes)
  - All applications via Stylix theming system
- **Reproducible**: Everything is declarative, so I can set it up the same way anywhere

## Software

### Core System

- **[Niri](https://github.com/YaLTeR/niri)**: Wayland-native tiling window manager with custom layouts and workspaces
- **[Firefox](https://www.mozilla.org/firefox/)**: Web browser with uBlock Origin, custom search engines, userstyles, BetterFox policies, and GNOME theme integration
- **[Kitty](https://github.com/kovidgoyal/kitty)**: GPU-accelerated terminal emulator with theme integration
- **[Fish](https://github.com/fish-shell/fish-shell)**: Shell with custom completions
- **[Hyprlock](https://github.com/hyprwm/Hyprlock)**: Screen locker with custom theme
- **[Yazi](https://github.com/sxyazi/yazi)**: Terminal file manager
- **[Astal](https://github.com/astrsh/astal)**: Desktop shell for widgets and system integration

### Development Tools

- **[VSCode](https://github.com/microsoft/vscode)**: Primary code editor with custom keybindings and themes
- **[Helix](https://github.com/helix-editor/helix)**: Modal text editor inspired by Vim
- **[jj (Jujutsu)](https://github.com/jj-vcs/jj)**: Version control system with strong history manipulation
- **[jj-hunk](https://github.com/knoopx/jj-hunk)**: Programmatic hunk selection tool for Jujutsu
- **[nix-ld](https://github.com/nix-community/nix-ld)**: Runs conventional Linux binaries on NixOS without repackaging

### Command Line Tools

- **Bat**: Cat clone with syntax highlighting
- **Btop**: Resource monitor
- **Delta**: Modern diff viewer
- **Fzf/Skim**: Command-line fuzzy finders
- **Nu Shell**: Shell with structured data processing
- **Starship**: Customizable prompt
- **Rclip**: CLIP-based command-line image search

### Control Scripts

Custom Nu-based scripts for system control:

- **brightness-control**: Adjust screen brightness
- **display-control**: Manage display settings and outputs
- **volume-control**: Control system and application volume
- **media-control**: Media playback controls
- **session-control**: Session management (lock, suspend, logout, etc.)
- **window-control**: Window management automation
- **tablet-mode-control**: Toggle tablet mode settings
- **voice-input-control**: Control voice input services
- **recording-indicator**: Visual indicator for active recordings
- **screen-recording**: Screen capture and recording utilities
- **google-authenticator-qr-decode**: Decode QR codes from Google Authenticator
- **pick-project**: Project selection utility
- **pick-document**: Document selection utility
- **dashboard**: System dashboard with inbox and project summaries
- **events**: Event management utilities
- **inbox**: Gmail inbox retrieval
- **project-summary**: Project overview utility

### Default Applications

Configured default applications across the system:

- **Browser**: Firefox ESR
- **Terminal**: Kitty
- **Editor**: Helix
- **File Manager**: Nautilus
- **Image Viewer**: Swayimg
- **PDF Viewer**: Evince
- **Video Player**: MPV
- **Music Player**: Plexamp

### Development Environments

The `modules/home-manager/packages/dev/` directory contains language-specific development environments:

- **[Crystal](https://github.com/crystal-lang/crystal)**: Compiler, Crystalline language server, Shards package manager, and Mint framework
- **[Go](https://github.com/golang/go)**: Compiler, gopls language server, Delve debugger, and build tools
- **JavaScript**: Node.js, Yarn, pnpm, and Bun
- **[Nix](https://github.com/NixOS/nix)**: nixpkgs-fmt formatter and development tools
- **[Python](https://github.com/python/cpython)**: Interpreter and development utilities
- **[Ruby](https://github.com/ruby/ruby)**: Interpreter and Bundler
- **[Rust](https://github.com/rust-lang/rust)**: Compiler and Cargo
- **System**: C/C++ compilers (GCC, Clang), build tools, and system-level utilities

### Launchers and Applications

- **[Vicinae](https://github.com/vicinaehq/vicinae/)**: Application launcher inspired by Raycast
- **Vicinae Extensions**: Custom extensions for the launcher

## How It's Organized

### My Machines

- **hosts/desktop/**: Main workstation with NVIDIA CUDA, BTRFS, container services (Watchtower, LLM), hardware-accelerated AI, and Glance dashboard
- **hosts/minibookx/**: Chuwi Minibook X N150 laptop with hardware-specific drivers and power management
- **hosts/hi10max/**: Touchscreen tablet with configurable touch gestures via julianjc84's niri fork
- **hosts/vm/**: Virtual machine setup for testing with demo scripts
- **hosts/steamdeck/**: Steam Deck configuration with VM test support
- **hosts/android/**: Android Virtual Framework (AVF) image configuration
- **hosts/live-usb/**: Bootable USB configuration for system recovery
- **hosts/installer/**: Unattended installer ISO that creates a 1GB EFI boot partition, 32GB encrypted swap, and XFS root with LUKS, installs the complete system with home-manager configuration, then auto-reboots

### Modules

- **modules/nixos/**: System-level configurations including:
  - **defaults/**: Global settings for apps, colors, display, fonts, system, and user
  - **services/**: System services (Plex Media Server, Traefik, auto-scrcpy, Flatpak, Keyd, etc.)
  - **system/**: Core system settings (boot, documentation, environment, hardware, networking, Nix configuration, packages, programs, users, virtualisation)
  - **theming/**: Stylix theming configuration
  - **wm/**: Window manager and desktop environment settings (Niri, packages, programs, services, XDG)
- **modules/home-manager/**: User environment configurations:
  - **packages/**: User packages and development tools
    - **dev/**: Language-specific development environments (Crystal, Go, JavaScript, Nix, Python, Ruby, Rust, System)
    - **cli.nix**: Command-line interface utilities
    - **gui.nix**: Graphical user interface packages
  - **programs/**: Application configurations (Bat, Btop, Delta, Firefox, Fish, Git, Gram, Helix, Hyprlock, JJ, Kitty, Micro, MPV, NH, Nix-index, Nu Shell, Pi-AI, Skim, Starship, Swayimg, Vicinae, Voxtype, WL-KBPtr, Yazi)
    - **firefox/**: Firefox with custom policies, profiles, and uBlock rules
    - **vicinae/**: Vicinae launcher configuration with custom scripts
    - **nu-shell/**: Nu Shell configuration with custom completions
  - **wm/**: Window manager user settings
    - **shell.nix**: Shell integration with window control
    - **niri/**: Niri window manager configuration (Astal shell, swayidle, niri-notify-focus)
    - **xdg/**: XDG desktop integration, GTK themes, dconf settings

### Overlays

Package customizations and fixes:

- **balatro.nix**: Balatro game modifications
- **glance.nix**: Glance dashboard customizations
- **gnome-control-center.nix**: GNOME Control Center patches
- **pegasus-frontend.nix**: Pegasus Frontend modifications
- **plotly.nix**: Plotly library patches
- **rclip.nix**: Rclip CLIP search overrides
- **retroarch.nix**: RetroArch emulator customizations
- **useless-desktop-items.nix**: Desktop item management

### Builders

Helper functions for creating package derivations:

- **theming/**: Theme builders (MoreWaita icons, Plymouth themes)
- **mkRenderMd.nix**: Markdown rendering utility

### Library

Utility functions for theming, color manipulation, and module loading:

- **theming/**: Color conversion utilities (hexToRGB, rgbToHex, hexToHSL, colorVariations, matchThemeColors)
- **listNixModulesRecusive.nix**: Custom module loading utility

### Packages

Custom package definitions in `pkgs/`:

**Applications:**

- [Neuwaita Icon Theme](https://github.com/knoopx/neuwaita-icon-theme): Custom icon theme
- [NFO Viewer](https://github.com/nfoview/nfoview): NFO file viewer
- **browser**: Custom Firefox browser wrapper
- **file-manager**: Custom file manager wrapper
- **image-viewer**: Custom image viewer wrapper (Swayimg)
- **pdf-viewer**: Custom PDF viewer wrapper (Evince)
- **terminal**: Custom terminal emulator wrapper
- **editor**: Custom editor wrapper (Helix)
- **tts**: Text-to-speech utilities

**Development & Productivity:**

- **codemapper**: Code mapping and navigation tool
- **romie**: ROM management utility
- **sem**: Semantic versioning tool
- **mdtt**: Markdown to text tool
- **wacli**: WhatsApp CLI client
- **gogcli**: GOG.com CLI client
- **pi-project**: Pi AI project integration
- **dashboard**: System dashboard with inbox and project summaries
- **events**: Event management utilities
- **inbox**: Gmail inbox retrieval
- **project-summary**: Project overview utility
- **inspect**: Codebase inspection tool
- **qmd**: Markdown workspace tool
- **weave**: CLI tool and driver
- **tolaria**: Markdown knowledge base manager
- **kuva**: Image viewing utility
- **numnum**: Image viewer
- **gritql**: Semantic code search
- **dawn**: Image optimization tool
- **freeze**: Image snapshot tool
- **nu-jupyter-kernel**: Jupyter kernel for Nushell
- **niri-notify-focus**: Window focus notification for Niri
- **toggle-panel**: Panel toggle utility
- **jj-hunk**: Hunk selection tool for Jujutsu

### Host-Specific Configurations

- **home/**: User-specific Home Manager configurations
- **flake.nix**: Main flake with inputs, outputs, and system configurations
- **flake.lock**: Dependency lock file for reproducible builds
