---
applyTo: "**"
---

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

# Coding Assistant Guidelines

## Build, Lint, and Test

- **Build:** `nix build path:.`
- **Run:** `nix run path:.`
- **Lint:** `nix run nixpkgs#pyright`
- **Command Execution:** Use `nix run nixpkgs#<command> -- <args>` for all tools and commands.

## General Coding Guidelines

- Favor user-provided references and documentation over your own assumptions and use appropriate mcp servers if necessary.
- Use Nix (`flake.nix`, `flake.lock`) for all dependencies and environments. Never install manually.
- Place all imports at the top of each file (stdlib, third-party, local).
- Use clear, modular code. Avoid unnecessary nesting and complexity.
- Prefer code over comments; comment only for clarity.
- Use exceptions for error handling and always log errors (with emojis for readability).
- Continue iterating without asking for confirmation when the objective is clear.
- Never commit secrets or credentials.
- Keep code modular and avoid circular imports.

## Environment and Tooling

- **Python:** FastAPI, torch, CUDA, transformers, diffusers, uv (use instead of pip), tqdm
- **JavaScript/TypeScript:** React, Vite, TailwindCSS, MobX, Bun
- **Shell & OS:** fish (not bash), NixOS, git, ags (astal), niri
- **Desktop/UI:** GTK, GNOME
