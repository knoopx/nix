{pkgs, ...}: let
  name = "wiki";
  root = "/home/knoopx/Documents/Notes";

  theme = ''
    html[data-theme="dark"] {
      color-scheme: dark;

      --ui-accent-color: var(--base0D);
      --ui-accent-text-color: color-mix(in srgb, var(--ui-accent-color), white 50%);
      --highlight-color: color-mix(in srgb, var(--base0A), transparent 50%);
      --link-color: var(--base0D);
      --link-missing-color: var(--base09);
      --meta-color: var(--base08);
      --meta-subtle-color: var(--base03);
      --subtle-color: var(--base03);
      --subtle-background-color: color-mix(in srgb, var(--base03), transparent 90%);

      --root-background-color: var(--base00);
      --root-color: var(--base05);

      --top-color: var(--base06);
      --top-background-color: var(--base01);
      --top-border-color: var(--base03);
      --top-sync-error-color: var(--top-color);
      --top-sync-error-background-color: color-mix(in srgb, var(--base08), black 50%);
      --top-saved-color: var(--base06);
      --top-unsaved-color: var(--base04);
      --top-loading-color: var(--base04);

      --panel-background-color: var(--base00);
      --panel-border-color: var(--base03);

      --bhs-background-color: var(--base00);
      --bhs-border-color: var(--base03);

      --modal-color: var(--base05);
      --modal-background-color: var(--base01);
      --modal-border-color: var(--base03);
      --modal-header-label-color: var(--ui-accent-text-color);
      --modal-help-background-color: var(--base02);
      --modal-help-color: var(--base05);
      --modal-selected-option-background-color: var(--ui-accent-color);
      --modal-selected-option-color: var(--base00);
      --modal-hint-background-color: color-mix(in srgb, var(--base0D), black 50%);
      --modal-hint-color: var(--base07);
      --modal-hint-inactive-background-color: var(--base02);
      --modal-hint-inactive-color: var(--base04);
      --modal-description-color: var(--base04);
      --modal-selected-option-description-color: var(--base06);

      --notifications-background-color: var(--base02);
      --notifications-border-color: var(--base04);
      --notification-info-background-color: var(--base0D);
      --notification-error-background-color: var(--base08);

      --button-background-color: var(--base03);
      --button-hover-background-color: color-mix(in srgb, var(--base03), var(--base04) 40%);
      --button-color: var(--base07);
      --button-border-color: var(--base03);
      --primary-button-background-color: var(--ui-accent-color);
      --primary-button-hover-background-color: color-mix(
        in srgb,
        var(--ui-accent-color),
        black 35%
      );
      --primary-button-color: var(--base07);
      --primary-button-border-color: transparent;

      --progress-background-color: var(--base03);
      --progress-sync-color: var(--base07);
      --progress-index-color: var(--base0A);

      --text-field-background-color: var(--button-background-color);

      --action-button-background-color: transparent;
      --action-button-color: var(--base04);
      --action-button-hover-color: var(--base0D);
      --action-button-active-color: var(--base0D);

      --editor-caret-color: var(--base07);
      --editor-selection-background-color: color-mix(in srgb, var(--base02), transparent 30%);
      --editor-panels-bottom-color: var(--base06);
      --editor-panels-bottom-background-color: var(--base01);
      --editor-panels-bottom-border-color: var(--base03);
      --editor-completion-detail-color: var(--base04);
      --editor-completion-detail-selected-color: var(--base06);
      --editor-list-bullet-color: var(--base04);
      --editor-heading-color: var(--base06);
      --editor-heading-meta-color: var(--meta-subtle-color);
      --editor-hashtag-background-color: color-mix(in srgb, var(--base0D), transparent 50%);
      --editor-hashtag-color: var(--base07);
      --editor-hashtag-border-color: color-mix(in srgb, var(--base0D), transparent 60%);
      --editor-ruler-color: var(--base03);
      --editor-naked-url-color: var(--link-color);
      --editor-link-color: var(--link-color);
      --editor-link-url-color: var(--link-color);
      --editor-link-meta-color: var(--meta-subtle-color);
      --editor-wiki-link-page-background-color: color-mix(in srgb, var(--base0D), transparent 92%);
      --editor-wiki-link-page-color: var(--link-color);
      --editor-wiki-link-page-missing-color: var(--link-missing-color);
      --editor-wiki-link-color: color-mix(in srgb, var(--base0D), var(--base05) 30%);
      --editor-command-button-color: var(--base07);
      --editor-command-button-background-color: var(--base03);
      --editor-command-button-hover-background-color: color-mix(in srgb, var(--base03), var(--base04) 40%);
      --editor-command-button-meta-color: var(--meta-subtle-color);
      --editor-command-button-border-color: var(--base03);
      --editor-line-meta-color: var(--meta-subtle-color);
      --editor-meta-color: var(--meta-color);
      --editor-table-head-background-color: color-mix(in srgb, var(--base03), transparent 60%);
      --editor-table-head-color: var(--base07);
      --editor-table-even-background-color: color-mix(in srgb, var(--base03), transparent 70%);
      --editor-blockquote-background-color: var(--subtle-background-color);
      --editor-blockquote-color: var(--subtle-color);
      --editor-blockquote-border-color: var(--base03);
      --editor-code-background-color: var(--subtle-background-color);
      --editor-struct-color: var(--base08);
      --editor-highlight-background-color: var(--highlight-color);
      --editor-code-comment-color: var(--meta-subtle-color);
      --editor-code-variable-color: var(--base0D);
      --editor-code-typename-color: var(--base0B);
      --editor-code-string-color: var(--base0A);
      --editor-code-number-color: var(--base0E);
      --editor-code-info-color: var(--subtle-color);
      --editor-code-atom-color: var(--base08);
      --editor-frontmatter-background-color: color-mix(in srgb, var(--base02), transparent 50%);
      --editor-frontmatter-color: var(--subtle-color);
      --editor-frontmatter-marker-color: var(--base07);
      --editor-widget-background-color: color-mix(in srgb, var(--base03), transparent 50%);
      --editor-task-marker-color: var(--subtle-color);
      --editor-task-state-color: var(--subtle-color);

      --editor-directive-mark-color: var(--base08);
      --editor-directive-color: var(--base04);
      --editor-directive-background-color: color-mix(in srgb, var(--base03), transparent 50%);
    }

    :root {
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
  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "zefhemel/silverbullet:latest";
      environmentFiles = ["${root}/.env"];
      volumes = [
        "${root}:/space"
      ];
    };
  };
}
