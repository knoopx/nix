{pkgs, ...}: let
  # extensions = pkgs.nix-vscode-extensions.forVSCodeVersion pkgs.vscode.version;
  extensions = pkgs.nix-vscode-extensions.vscode-marketplace;
in
  with extensions; [
    # devdocs-adapter.devdocs-adapter
    # foxundermoon.shell-format
    # grapecity.gc-excelviewer
    # hall.draw
    # inferrinizzard.prettier-sql-vscode
    # lunaryorn.fish-ide
    # mdmohiburrahman.notionkeys-for-markdown
    # ms-dotnettools.csharp
    # ms-dotnettools.dotnet-interactive-vscode
    # ms-dotnettools.vscode-dotnet-runtime
    # ms-toolsai.jupyter
    # ms-toolsai.jupyter-keymap
    # ms-toolsai.jupyter-renderers
    # ms-toolsai.vscode-jupyter-cell-tags
    # ms-toolsai.vscode-jupyter-slideshow
    # nguyenngoclong.terminal-keeper
    # piousdeer.adwaita-theme
    # pmneo.tsimporter
    # rangav.vscode-thunder-client
    # redhat.vscode-xml
    # redhat.vscode-yaml
    # semanticdiff.semanticdiff
    # skyapps.fish-vscode
    # takumii.markdowntable
    # tamasfe.even-better-toml
    # tanvir.ollama-modelfile
    # teclado.vscode-nginx-format
    # tetradresearch.vscode-h2o
    # unifiedjs.vscode-mdx
    # usernamehw.todo-md
    # visualstudioexptteam.intellicode-api-usage-examples
    # visualstudioexptteam.vscodeintellicode
    # vitest.explorer
    # william-voyek.vscode-nginx
    # xyc.vscode-mdx-preview
    # kisstkondoros.vscode-gutter-preview
    # yanivmo.navi-cheatsheet-language

    # bmalehorn.vscode-fish
    # bradlc.vscode-tailwindcss
    # dbcode.dbcode

    # ai
    github.copilot
    github.copilot-chat

    # ruby
    # jnbt.vscode-rufo
    # charliermarsh.ruff
    # shopify.ruby-lsp

    # javascript/typescript
    wallabyjs.console-ninja
    ms-vscode.vscode-typescript-next

    # css
    # csstools.postcss

    # nix
    bbenoist.nix
    jnoortheen.nix-ide
    kamadorueda.alejandra

    # misc
    britesnow.vscode-toggle-quotes
    ast-grep.ast-grep-vscode
    file-icons.file-icons
    esbenp.prettier-vscode
    # naumovs.color-highlight
    # nortakales.vs-qalc

    # pythong
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
  ]
