{ pkgs, config, lib, ... }:
let
  enabled = config.defaults.development.system;
in
{
  environment.systemPackages = lib.mkIf enabled (with pkgs; [
    # bash-language-server
    # fish-lsp
    ast-grep # Code search using AST-based pattern matching
    binsider # Analyzer of executables using a TUI
    cmake # Cross-platform build system
    codemapper # Code intelligence on your CLI for AI agents
    fswatch # File system event watcher
    gcc # GNU C compiler
    gh # GitHub CLI
    gnumake # GNU make
    jj-hunk # Jujutsu hunk splitting tool
    jjui # TUI for Jujutsu VCS
    just # Command runner
    pi-coding-agent # Coding agent CLI
    pkg-config # Build system helper for compiler/linker flags
    sem # Command-line tool for semantic versioning
    shfmt # Shell script formatter
  ]);
}
