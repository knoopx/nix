{pkgs, ...}: let
  name = "wiki";
  root = "/home/knoopx/Documents/";
  # root = "/mnt/storage/silverbullet";
  public-url = "https://${name}.knoopx.net";

  theme = ''
      * {
      --base00: #1e1e2e;
      --base01: #181825;
      --base02: #313244;
      --base03: #45475a;
      --base04: #585b70;
      --base05: #cdd6f4;
      --base06: #f5e0dc;
      --base07: #b4befe;
      --base08: #f38ba8;
      --base09: #fab387;
      --base0A: #f9e2af;
      --base0B: #a6e3a1;
      --base0C: #94e2d5;
      --base0D: #89b4fa;
      --base0E: #cba6f7;
      --base0F: #fad000;

      --editor-font: monospace;
      --modal-color: var(--base05);
      --editor-width: 1024px;
      --root-color: var(--base05);
      --root-background-color: var(--base00);
      --top-background-color: var(--base01);
      --top-color: var(--base05);
      --top-border-color: var(--base02);
      --top-sync-error-background-color: var(--base08);
      --action-button-color: var(--base05);
      --editor-heading-color: var(--base0A);
      --editor-wiki-link-page-missing-color: var(--base08);
      --editor-link-color: var(--base0D);
      --modal-header-label-color: var(--base0D);
      --modal-background-color: var(--base01);
      --modal-border-color: var(--base02);
      --modal-help-background-color: var(--base00);

      --modal-selected-option-color: var(--base02);
      --modal-selected-option-background-color: var(--base07);
      --modal-hint-background-color: var(--base02);

      --editor-table-head-background-color: var(--base01);
      --editor-table-even-background-color: var(--base02);

      --editor-code-background-color: var(--base01);
      --editor-code-variable-color: var(--base07);
      --editor-code-string-color: var(--base0B);
      --editor-code-comment-color: var(--base04);
        line-height: 1.5 !important;
    }

    #sb-main .cm-editor {
        font-size: 15px;
    }

    .cm-placeholder {
        color: var(--base04) !important;
    }

    .sb-line-fenced-code {
    /*     border-radius: 5px !important; */
    }
    .sb-modal-box .sb-header label, .sb-modal-box .sb-help-text {
        display: none;
    }

    .sb-modal-box .sb-result-list {
      max-height: 512px !important;
    };

    .sb-modal-box {
        font-family: var(--editor-font) !important;
    }

    .cm-panels {
      border: none !important;
    }

    .cm-search {
        background-color: var(--base02);
    }

    .cm-button, .cm-textfield {
        background-image: none !important;
        background-color: var(--base02);
        border-color: var(--base03) !important;
        border-radius: 3px !important;
        padding-top: 6px !important;
        padding-bottom: 6px !important;
    }


    .cm-button {
        border: none !important;
        background-color: var(--base03);

    }
  '';
in {
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "sb" ''
      pushd ${root}
      fd --type f -e md . | grep -v Library/Core | grep -v Templates | awk '{print substr($0, 1, length($0)-3) "\t" $0}' | sort --ignore-case | fzf --reverse --with-nth=1 --preview-window=right:70% \
          --delimiter='\t' \
          --preview 'glow --style=dark {2}' \
          --bind="enter:execute(sb-open {2})"
      popd
    '')

    (writeShellScriptBin "sb-open" ''
      # set -l base_url "${public-url}"
      # set -l url_path (echo $path | sed 's/\.md$//' | sed 's/ /%20/g')
      # xdg-open "$base_url/$url_path"
      ${pkgs.micro}/bin/micro $1
    '')
  ];

  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "zefhemel/silverbullet:v2";
      environmentFiles = ["${root}/.env"];
      volumes = [
        "${root}:/space"
      ];
    };
  };
}
