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
- Complete system configuration for multiple hosts (desktop, macbook, vm)
- User environment configuration via Home Manager
- Custom theming with Stylix integration
- Modular and extensible architecture
- Custom packages and overlays

## Directory Structure

### Core Configuration Files
```
├── flake.nix           # Main flake configuration and inputs
├── defaults.nix        # Global defaults and shared settings
└── README.md          # Basic usage instructions
```

### NixOS Host Configurations
```
hosts/
├── desktop/           # Desktop machine configuration
├── macbook/           # MacBook configuration
└── vm/               # Virtual machine configuration
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
│   ├── packages.nix  # User packages
│   ├── programs/     # Program configurations
│   ├── services/     # User services
│   └── wm/           # Window manager configurations
└── nixos/           # NixOS Modules
    ├── services/    # Core System services
    ├── system/      # Core system settings
    ├── theming/     # System theming
    └── wm/          # Graphical desktop related configuration
```

### Other Modules
```
builders/           # Custom builders (functions that return new derivations)
overlays/          # Package overlays, used for fixing quirks/annoyances
pkgs/             # Custom packages
lib/              # Utility functions
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
```

#### Update flake dependencies
```bash
nix flake update
```

### 2. Package Management

#### Add packages to user environment
```nix
# Edit modules/home-manager/packages.nix
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
```

#### Check configuration syntax
```bash
# Validate flake
nix flake check

# Show flake outputs
nix flake show
```

#### Evaluate expressions
```bash
# Evaluate flake attributes
nix eval path:.#nixosConfigurations.desktop.config.system.stateVersion

# Pretty print with --json
nix eval --json path:.#nixosConfigurations.desktop.config.environment.systemPackages | jq
```

## Key Features

- **Modular Architecture**: Easily enable/disable features per host or user
- **Automatic Module Discovery**: Uses `listNixModulesRecusive` for auto-importing
- **Unified Theming**: Stylix provides consistent theming across applications
- **Multiple Host Support**: Desktop, laptop, and VM configurations
- **Container Integration**: Organized container service definitions
- **Development Ready**: Pre-configured development tools and environments
- **Custom Packages**: Easy addition of custom or modified packages

## File Naming Conventions

The repository uses **haumea** for most module loading (see flake.nix), but `listNixModulesRecusive` is used in specific cases (hosts, home configurations). For modules handled by `listNixModulesRecusive`:

- `modulename.nix`: Standalone modules (auto-imported)
- `_filename.nix`: Private/helper modules (excluded from auto-import, manually imported by other modules)
