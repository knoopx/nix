# Copilot Instructions for This NixOS Dotfiles Repository

## Project Overview

- **Purpose:** Modular, declarative NixOS + Home Manager configuration for multiple hosts and users, with unified theming, keyboard-driven workflows, and reproducible environments.
- **Structure:**
  - `flake.nix`, `flake.lock`: Entrypoint for all builds, inputs, and overlays
  - `hosts/`: Per-machine system configs (e.g., `desktop/`, `minibookx/`, `vm/`)
  - `home/`: User-specific Home Manager configs
  - `modules/nixos/`: System-level modules (services, hardware, theming, etc.)
  - `modules/home-manager/`: User-level modules (apps, dotfiles, window managers)
  - `overlays/`, `pkgs/`, `lib/`, `builders/`: Custom packages, overlays, and utility functions

## Key Conventions & Patterns

- **Modularization:**
  - Use standalone `modulename.nix` for auto-imported modules
  - Use `_filename.nix` for private/helper modules (not auto-imported)
  - Most module loading is via [haumea](https://github.com/nix-community/haumea), but some use `listNixModulesRecusive`
- **No Dead Code:**
  - When removing features, delete code entirely—do not comment out or leave unused logic
- **Unified Theming:**
  - Stylix and custom theming modules propagate color schemes to all apps and userstyles
- **Keyboard-Driven UX:**
  - Window management (Niri), app launchers, and navigation are optimized for keyboard use
- **Secrets:**
  - Use `secret-tool` for API keys and credentials; never commit secrets

## Developer Workflows

- **Build/Deploy:**
  - System: `nh os switch path:.` (preferred) or `sudo nixos-rebuild switch --flake path:.`
  - Home: `home-manager switch --flake path:.`
  - Update flakes: `nix flake update`
- **Testing & Debugging:**
  - Test in VM: `nix run path:.#vm`
  - Validate: `nix flake check`, `nix flake show`
  - Evaluate: `nix eval path:.#nixosConfigurations.<host>.config.*`
- **Package Management:**
  - Add user packages: `modules/home-manager/packages.nix`
  - Add overlays: `overlays/`
  - Custom packages: `pkgs/`
- **Cheatsheets:**
  - `modules/home-manager/navi/cheats/` contains navi cheats for common tasks (Nix, jq, downloads, etc.)

## Coding Style

- **Nix:**
  - Use clear argument names, type hints in comments if needed
  - Comment only for clarity
- **Python/JS/TS:**
  - Always use type annotations (Python, TS)
  - Use Google-style docstrings (Python)
  - Use ES6 imports, arrow functions, and explicit types (TS)
  - Log with emojis for readability
- **General:**
  - Place all imports at the top
  - Favor modular, simple code; avoid circular imports
  - Never commit secrets or credentials

## Commit Messages

- Use [conventional commits](https://www.conventionalcommits.org/) with emoji and scope, e.g.:
  - `feat(wm): ✨ Add new Niri window rule`
  - `fix(home): 🐛 Correct package path`
- See `modules/nixos/ai/instructions/commit.md` for full conventions and examples

## External Integrations

- **Nixpkgs**: All dependencies and tools are managed via Nix flakes
- **Home Manager**: User-level config and dotfiles
- **Stylix**: Theming
- **Vibeapps**: Custom GTK micro-apps (see `README.md`)
- **Glance**: Dashboard (see overlays and services)

## References

- See `README.md` and `AGENT.md` for more details, usage, and architecture diagrams
- For Nix options: https://search.nixos.org/options, https://home-manager-options.extranix.com/, https://noogle.dev/

---

**If unsure about a pattern or workflow, check the relevant module in `modules/`, the cheatsheets in `navi/cheats/`, or the usage examples in `AGENT.md`.**
