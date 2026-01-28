{pkgs, ...}: let
  extensions = pkgs.nix-vscode-extensions.vscode-marketplace;
in
  # https://raw.githubusercontent.com/nix-community/nix-vscode-extensions/0770828946622d7066584d64cfd9ac38d8ac7086/data/cache/vscode-marketplace-latest.json
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
    solomonkinard.git-blame
    thenuprojectcontributors.vscode-nushell-lang
    visualjj.visualjj
  ]
