{pkgs, ...}: {
  home.packages = with pkgs; [
    # Build & config
    cmake
    gcc
    gnumake
    pkg-config

    # Code search & analysis
    ast-grep
    binsider
    codemapper
    sem

    # File watching
    fswatch

    # CLI utilities
    gh
    just
    shfmt

    # Version control (jj)
    jj-hunk
    jjui

    # AI
    pi-coding-agent

    # fish-lsp
    # bash-language-server
  ];
}
