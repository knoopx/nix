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
  - Terminal emulator (Kitty)
  - Text editors (VSCode, Helix)
  - Window manager (Niri with custom color schemes)
  - All applications via Stylix theming system
- **Reproducible**: Everything is declarative, so I can set it up the same way anywhere

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

### Host-Specific Configurations

- **home/**: User-specific Home Manager configurations
- **flake.nix**: Main flake with inputs, outputs, and system configurations
- **flake.lock**: Dependency lock file for reproducible builds
