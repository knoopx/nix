# Coding Style and Review Policy

## Remove, Don't Comment Out

When asked to remove a feature, option, or code path, **delete the code entirely** instead of commenting it out or leaving dead code. Do not leave commented-out code or references to removed features. The codebase should remain clean and free of unused logic or options.

This applies to:

- Command-line options
- Default values
- Help messages
- Any code path or logic related to the removed feature

**Example:**

If asked to remove an `output_file` option, delete all code, help text, and logic related to it. Do not leave comments like `# output_file removed` or `# output_file option ignored`.

---

# NixOS Dotfiles Repository Structure & Usage Guide

This is a comprehensive NixOS configuration repository (kOS) that manages both system-level and user-level configurations using Nix flakes. The repository follows a modular structure for maintainability and reusability.

## Repository Overview

This is a **NixOS + Home Manager** configuration system that provides:

- Complete system configuration for multiple hosts (desktop, live-usb, minibookx, vm)
- User environment configuration via Home Manager
- Custom theming with Stylix integration
- Modular and extensible architecture
- Custom packages and overlays

## Directory Structure

### Core Configuration Files

```
├── flake.nix           # Main flake configuration and inputs
└── README.md          # Basic usage instructions
```

### NixOS Host Configurations

```
hosts/
├── desktop/           # Desktop machine configuration
│   ├── containers/    # Container configurations (silverbullet, watchtower)
│   ├── home-manager/  # Host-specific home-manager modules
│   │   ├── easy-effects/
│   │   ├── glance/
│   │   └── programs/
│   ├── services/      # Host-specific services
│   ├── boot.nix
│   ├── default.nix
│   ├── filesystems.nix
│   ├── hardware.nix
│   ├── nvidia.nix
│   └── services.nix
├── live-usb/          # Live USB configuration
├── minibookx/         # Chuwi Minibook X configuration
│   ├── boot.nix
│   ├── default.nix
│   ├── hardware.nix
│   └── services.nix
└── vm/               # Virtual machine configuration
    ├── default.nix
    └── demo.sh
```

### Home-Manager Users Configuration

```
home/
└── knoopx.nix        # User-specific Home Manager configuration
```

### Nix Modules

```
modules/
├── home-manager/     # Home-Manager Modules
│   ├── environment.nix
│   ├── misc.nix
│   ├── packages/     # User packages
│   │   ├── cli.nix
│   │   ├── gtk.nix
│   │   └── dev/      # Development language packages
│   │       ├── crystal.nix, go.nix, javascript.nix, nix.nix
│   │       ├── python.nix, ruby.nix, rust.nix, system.nix
│   ├── programs/     # Program configurations
│   │   ├── btop.nix, cromite.nix, fish.nix, fzf.nix, git.nix
│   │   ├── helix.nix, hyprlock.nix, kitty.nix, nh.nix
│   │   ├── nix-index.nix, skim.nix
│   │   ├── television.nix, vicinae.nix, yazi.nix
│   │   ├── firefox/   # Firefox configuration
│   │   ├── opencode-ai/  # OpenCode AI configuration
│   │   └── vscode/    # VSCode configuration
│   ├── services/     # User services
│   │   ├── clipman.nix
│   │   └── webdav.nix
│   └── wm/           # Window manager configurations
│       ├── niri/      # Niri window manager
│       │   ├── astal-shell.nix, config.nix, services.nix, swayidle.nix
│       └── xdg/       # XDG desktop integration
│           ├── dconf/ # GNOME dconf settings
│           ├── xdg/   # XDG specifications
│           └── gtk.nix
└── nixos/           # NixOS Modules
    ├── defaults/    # Default configurations
    │   ├── ai.nix, colors.nix, display.nix, fonts.nix
    │   ├── system.nix, user.nix
    ├── services/    # Core System services
    │   ├── auto-scrcpy.nix
    │   ├── flatpak.nix, keyd.nix, plex.nix
    │   ├── services.nix, traefik.nix
    ├── system/      # Core system settings
    │   ├── boot.nix, documentation.nix, environment.nix
    │   ├── hardware.nix, networking.nix, nix-ld.nix
    │   ├── nix.nix, nixpkgs.nix, packages.nix, programs.nix
    │   ├── system.nix, users.nix, virtualisation.nix
    ├── theming/     # System theming
    │   └── stylix.nix
    └── wm/          # Graphical desktop related configuration
        ├── niri.nix, packages.nix, programs.nix
        ├── services.nix, xdg.nix
```

### Other Modules

```
builders/           # Custom builders (functions that return new derivations)
└── theming/       # Theme-related builders
    ├── mkMoreWaitaIconTheme.nix
overlays/          # Package overlays, used for fixing quirks/annoyances
├── balatro.nix, fish.nix, geary.nix, glance.nix
├── gnome-control-center.nix, kitty.nix, niri.nix
├── opencode.nix, pegasus-frontend.nix, retroarch.nix
├── useless-desktop-items.nix, useless-files.nix
pkgs/             # Custom packages
├── cromite.nix, neuwaita-icon-theme.nix, nfoview.nix
lib/              # Utility functions
├── theming/       # Theme-related utilities
│   ├── colorVariations.nix, hexToHSL.nix, hexToRGB.nix
│   ├── matchThemeColors.nix, rgbToHex.nix
└── listNixModulesRecusive.nix  # Module listing utility
```

## Common Tasks & Examples

### 1. System Management

**Important Note**: Always prefix flake path with `path:`, otherwise nix won't pick up uncommited changes.

#### Local system rebuild

```bash
# Build and switch system configuration
nh os switch path:.

# Build without switching (for testing)
sudo nixos-rebuild build --flake path:.

# Build home configuration only
nh home switch path:.
```

#### Update flake dependencies

```bash
nix flake update
```

### 2. Package Management

#### Add packages to user environment

```nix
# Edit modules/home-manager/packages/ files (e.g., cli.nix)
{
  home.packages = with pkgs; [
    # Add new packages here
    firefox
    vscode
    git
  ];
}
```

#### Create custom package

```nix
# Create pkgs/mypackage.nix
{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "mypackage";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "user";
    repo = "mypackage";
    rev = version;
    sha256 = "...";
  };

  # Build instructions...
}
```

#### Add package overlay

```nix
# Create overlays/myoverlay.nix
final: prev: {
  mypackage = prev.mypackage.overrideAttrs (old: {
    # Modifications to existing package
  });
}
```

### 3. Testing & Debugging

#### Test in VM

```bash
# Build and run VM for testing
nix run path:.#vm

# Build VM without running
nix build path:.#packages.default
```

#### Check configuration syntax

```bash
# Validate flake
nix flake check

# Lint/Format nix files
alejandra [--check] <file or directory>

# Format entire repository
alejandra .
```

#### Show flake outputs

```bash
nix flake show

# Show available packages
nix flake show path:.#packages.x86_64-linux
```

#### Evaluate expressions

```bash
# Evaluate flake attributes
nix eval path:.#nixosConfigurations.desktop.config.system.stateVersion

# Pretty print with --json
nix eval --json path:.#nixosConfigurations.desktop.config.environment.systemPackages | jq

# Check specific package availability
nix eval path:.#packages.x86_64-linux.neuwaita-icon-theme
```

## Module Loading System

The repository uses a hybrid module loading approach:

### Haumea Loading

Most modules use **haumea** for automatic module discovery and loading:

- `modules/nixos/` (except defaults/)
- `modules/home-manager/` (except top-level files)
- `overlays/` (verbatim loader)
- `pkgs/`, `lib/`, `builders/`

### listNixModulesRecursive Loading

Custom recursive loader used for:

- `modules/nixos/defaults/` - Auto-imported into all NixOS configurations
- Host configurations (`hosts/*/`) - All `.nix` files auto-imported
- Home Manager configurations - All `.nix` files auto-imported

## File Naming Conventions

For modules handled by `listNixModulesRecursive`:

- `modulename.nix`: Standalone modules (auto-imported)
- `_filename.nix`: Private/helper modules (excluded from auto-import, manually imported)

## Flake Inputs

The configuration uses numerous external inputs:

- **Core**: nixpkgs-unstable, home-manager, haumea
- **Theming**: stylix, nix-colors, neuwaita, adwaita-colors
- **Window Management**: niri, xwayland-satellite, astal-shell
- **Applications**: firefox-addons, betterfox
- **Hardware**: nix-chuwi-minibook-x
- **Development**: nix-vscode-extensions, autofirma-nix
- **Social**: vicinae

## Host-Specific Configurations

### Desktop

- NVIDIA graphics support
- Container services (SilverBullet, Watchtower)
- EasyEffects audio configuration
- Glance dashboard
- Autofirma integration

### MinibookX

- Chuwi Minibook X hardware support
- Custom kernel modules
- Power management

### Live USB

- Portable system configuration
- Minimal footprint

### VM

- Testing environment
- Demo scripts
