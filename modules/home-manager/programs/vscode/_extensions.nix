{pkgs, ...}: let
  extensions = pkgs.nix-vscode-extensions.vscode-marketplace;
in
  with extensions; [
    ast-grep.ast-grep-vscode
    bbenoist.nix
    britesnow.vscode-toggle-quotes
    esbenp.prettier-vscode
    file-icons.file-icons
    github.copilot
    github.copilot-chat
    jnoortheen.nix-ide
    kamadorueda.alejandra
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.vscode-pylance
    ms-vscode.vscode-typescript-next
    tamasfe.even-better-toml
    wallabyjs.console-ninja
  ]
