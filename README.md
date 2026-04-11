# kOS

This is my personal NixOS configuration for a clean, keyboard-focused development machine. I built it to keep things simple, consistent, and distraction-free while coding.

https://github.com/user-attachments/assets/d45f3687-cfda-47a7-b2e9-3c0dbdb562bf

## Try Out

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

**⚠️ Warning**: The installer will automatically erase and partition the first unused disk it finds. Use with caution.

## What I Focus On

- **Minimal clutter**: Shell has no widgets and apps take the whole vertical space. Keyboard-driven workflow throughout.
- **Unified styling**: Consistent colors, fonts, and styles across:
  - System GTK/Qt themes and custom Neuwaita icon theme (merged with MoreWaita)
  - Terminal emulator (Kitty)
  - Text editors (VSCode, Helix)
  - Window manager (Niri with custom color schemes)
  - All applications via Stylix theming system
- **Reproducible**: Everything's declarative, so I can set it up the same way anywhere

## Software

### Core System

- **[Niri](https://github.com/YaLTeR/niri)**: A modern, Wayland-native tiling window manager that provides efficient keyboard-driven window management with custom layouts and workspaces
- **[Firefox](https://www.mozilla.org/firefox/)**: Web browser optimized for privacy with [uBlock Origin](https://github.com/gorhill/uBlock) for ad-blocking, custom search engines, and userstyles for consistent theming. Includes policies for enhanced security and performance thanks to [BetterFox](https://github.com/yokoffing/BetterFox) and GNOME theme integration
- **[Chromite](https://github.com/beetlelust/chromite)**: Privacy-focused Chromium fork with enhanced security features
- **[Kitty](https://github.com/kovidgoyal/kitty)**: GPU-accelerated terminal emulator with theme integration
- **[Fish](https://github.com/fish-shell/fish-shell)**: The user-friendly command line shell with custom completions
- **[Hyprlock](https://github.com/hyprwm/Hyprlock)**: Screen locker with custom theme
- **[Yazi](https://github.com/sxyazi/yazi)**: Modern terminal file manager
- **[Astal](https://github.com/astrsh/astal)**: Dynamic shell for desktop widgets and system integration

### Development Tools

- **[VSCode](https://github.com/microsoft/vscode)**: Primary code editor with custom keybindings, themes, and productivity tools
- **[Helix](https://github.com/helix-editor/helix)**: Modal text editor inspired by Vim
- **[jj (Jujutsu)](https://github.com/jj-vcs/jj)**: Version control system with superior history manipulation and workflow management
- **[jj-hunk](https://github.com/knoopx/jj-hunk)**: Programmatic hunk selection tool for Jujutsu
- **[nix-ld](https://github.com/nix-community/nix-ld)**: Enables the experience (and caveats) of conventional Linux distros into NixOS, avoiding the need to re-package every single binary

### Command Line Tools

- **Bat**: Cat clone with syntax highlighting
- **Btop**: Resource monitor
- **Delta**: Modern diff viewer
- **Fzf/Skim**: Command-line fuzzy finders
- **Nu Shell**: Modern shell with structured data processing
- **Starship**: Customizable prompt

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

### Default Applications

Configured default applications across the system:

- **Browser**: Firefox ESR
- **Terminal**: Kitty
- **Editor**: Helix
- **File Manager**: Nautilus
- **Image Viewer**: Eye of GNOME (EOG)
- **Video Player**: MPV
- **Music Player**: Decibels

### Development Environments

The `modules/home-manager/packages/dev/` directory contains language-specific development environments, each providing essential tools for programming in that language:

- **[Crystal](https://github.com/crystal-lang/crystal)**: Compiler, [Crystalline](https://github.com/elbywan/crystalline) language server, [Shards](https://github.com/crystal-lang/shards) package manager, and [Mint framework](https://github.com/mint-lang/mint) for building web applications
- **[Go](https://github.com/golang/go)**: Compiler, [gopls](https://github.com/golang/tools/tree/master/gopls) language server, [Delve](https://github.com/go-delve/delve) debugger, and build tools for efficient Go development
- **JavaScript**: [Node.js](https://github.com/nodejs/node) runtime, package managers ([Yarn](https://github.com/yarnpkg/yarn), [pnpm](https://github.com/pnpm/pnpm)), and [Bun](https://bun.sh) for modern web development
- **[Nix](https://github.com/NixOS/nix)**: [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt) formatter and development tools for Nix language development
- **[Nu Shell](https://www.nushell.sh)**: Modern shell with plugins for data processing (polars, query, notifications, highlight, skim) and formatting (nufmt)
- **[Python](https://github.com/python/cpython)**: Interpreter and development utilities
- **[Ruby](https://github.com/ruby/ruby)**: Interpreter, [Bundler](https://github.com/rubygems/bundler) for dependency management
- **[Rust](https://github.com/rust-lang/rust)**: Compiler and [Cargo](https://github.com/rust-lang/cargo) package manager
- **System**: C/C++ compilers ([GCC](https://gcc.gnu.org/), [Clang](https://clang.llvm.org/)), build tools, and system-level development utilities

### Launchers and Extensions

- **[Vicinae](https://github.com/vicinaehq/vicinae/)**: Application launcher inspired by Raycast
- **[Astal](https://github.com/astrsh/astal)**: Dynamic desktop shell for widgets and system integration
- **Camper**: Home automation control integration
- **Vicinae Extensions**: Custom extensions for the launcher

## How It's Organized

### My Machines

- **desktop/**: Main workstation featuring:
  - NVIDIA graphics with CUDA support
  - [BTRFS](https://btrfs.readthedocs.io/en/latest/) filesystem with advanced features
  - Container services ([Watchtower](https://github.com/containrrr/watchtower) for updates, [SilverBullet](https://silverbullet.md/))
  - Hardware acceleration for AI models
  - EasyEffects audio configuration
  - Glance dashboard
- **minibookx/**: Chuwi Minibook X N150 laptop configuration:
  - Hardware-specific drivers and optimizations
  - Power management and battery optimizations
- **vm/**: Virtual machine setup for testing with demo scripts
- **steamdeck/**: Steam Deck configuration with VM test support
- **android/**: Android Virtual Framework (AVF) image configuration
- **live-usb/**: Bootable USB configuration for system recovery
- **installer/**: Unattended installer ISO that automatically partitions and installs kOS:
  - Creates 1GB EFI boot partition + XFS root filesystem
  - Installs complete system with home-manager configuration
  - Auto-reboots after successful installation

### Modules

- **modules/nixos/**: System-level configurations including:
  - **defaults/**: Global settings for apps, colors, display, fonts, system, and user
  - **services/**: System services ([Plex Media Server](https://www.plex.tv/), [Traefik](https://github.com/traefik/traefik), Android photo backup, auto-scrcpy, Flatpak, Keyd, etc.)
  - **system/**: Core system settings (boot, documentation, environment, hardware, networking, Nix configuration, packages, programs, users, virtualisation)
  - **theming/**: [Stylix](https://github.com/danth/stylix) theming configuration
  - **wm/**: Window manager and desktop environment settings (Niri, packages, programs, services, XDG)
- **modules/home-manager/**: User environment configurations:
  - **packages/**: User packages and development tools
    - **dev/**: Language-specific development environments (Crystal, Go, JavaScript, Nix, Nu Shell, Python, Ruby, Rust, System)
    - **cli.nix**: Command-line interface utilities
    - **gui.nix**: Graphical user interface packages
  - **programs/**: Application configurations (VSCode, Firefox, Kitty, Fish, Helix, Hyprlock, etc.)
    - **firefox/**: Firefox with custom policies, profiles, and uBlock rules
    - **vicinae/**: Vicinae launcher configuration with custom scripts

    - **nu-shell/**: Nu Shell configuration with custom completions
    - Other programs: bat, btop, chromite, delta, fish, git, helix, hyprlock, jj, kitty, micro, nix-index, pi-ai, skim, starship, voxtype, yazi

  - **wm/**: Window manager user settings
    - **shell.nix**: Shell integration with window control
    - **niri/**: Niri window manager configuration
    - **xdg/**: XDG desktop integration, GTK themes, dconf settings

### Overlays

Package customizations and fixes:

- **balatro.nix**: Balatro game modifications
- **glance.nix**: Glance dashboard customizations
- **gnome-control-center.nix**: GNOME Control Center patches
- **pegasus-frontend.nix**: Pegasus Frontend modifications
- **retroarch.nix**: RetroArch emulator customizations
- **useless-desktop-items.nix**: Desktop item management
- **plotly.nix**: Plotly library patches
- **pi.nix**: Pi AI integration

### Builders

Helper functions for creating package derivations:

- **theming/**: Theme builders (MoreWaita icons, Plymouth themes, Stylix Firefox/Gnome themes)

### Library

Utility functions for theming, color manipulation, and module loading:

- **theming/**: Color conversion utilities (hexToRGB, rgbToHex, etc.)
- **listNixModulesRecusive.nix**: Custom module loading utility

### Packages

Custom package definitions in `pkgs/`:

**Control & Utility Scripts:**

- brightness-control, display-control, volume-control, media-control
- session-control, window-control, tablet-mode-control
- voice-input-control, recording-indicator, screen-recording
- google-authenticator-qr-decode
- pick-project, pick-document

**Applications:**

- [Neuwaita Icon Theme](https://github.com/knoopx/neuwaita-icon-theme): Custom icon theme
- [NFO Viewer](https://github.com/nfoview/nfoview): NFO file viewer
- **browser**: Custom Firefox/Chromium browser wrapper
- **file-manager**: Custom file manager wrapper
- **image-viewer**: Custom image viewer wrapper
- **terminal**: Custom terminal emulator wrapper
- **editor**: Custom editor wrapper

- **cromite**: Privacy-focused Chromium fork
- **tts**: Text-to-speech utilities

**Development & Productivity:**

- **codemapper**: Code mapping and navigation tool
- **jj-hunk**: Programmatic hunk selection for Jujutsu
- **romie**: ROM management utility
- **sem**: Semantic versioning tool
- **mdtt**: Markdown to text tool
- **wacli**: WhatsApp CLI client
- **gogcli**: GOG.com CLI client
- **pi-project**: Pi AI project integration

### Host-Specific Configurations

- **home/**: User-specific Home Manager configurations
- **flake.nix**: Main flake with inputs, outputs, and system configurations
- **flake.lock**: Dependency lock file for reproducible builds
