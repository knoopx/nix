{
  pkgs,
  config,
  nixosConfig,
  lib,
  ...
} @ inputs: {
  "update.mode" = "none";
  "python.languageServer" = "Pylance";
  "extensions.ignoreRecommendations" = true;
  "terminal.integrated.enableImages" = true;
  "terminal.integrated.enableMultiLinePasteWarning" = "never";
  "terminal.integrated.env.linux" = {};
  "security.workspace.trust.enabled" = false;
  "window.titleBarStyle" = "custom";

  "diffEditor.ignoreTrimWhitespace" = true;
  "editor.fontLigatures" = true;
  "editor.fontSize" = lib.mkForce 12;
  "editor.formatOnSaveMode" = "file";
  "editor.inlineSuggest.enabled" = true;
  "editor.multiCursorModifier" = "ctrlCmd";
  "editor.scrollBeyondLastLine" = false;
  "editor.semanticHighlighting.enabled" = true;
  "editor.suggestSelection" = "first";
  "editor.wordWrap" = "off";

  "custom-ui-style.font.monospace" = nixosConfig.defaults.fonts.monospace.name;
  "custom-ui-style.font.sansSerif" = nixosConfig.defaults.fonts.sansSerif.name;

  "editor.minimap.enabled" = false;
  "editor.minimap.maxColumn" = 80;
  "editor.minimap.scale" = 1;

  "emmet.triggerExpansionOnTab" = false;

  "explorer.confirmDelete" = false;
  "explorer.confirmDragAndDrop" = false;
  "explorer.confirmPasteNative" = false;
  "explorer.fileNesting.enabled" = true;

  "files.trimFinalNewlines" = true;
  "files.trimTrailingWhitespace" = true;

  "git.allowForcePush" = true;
  "git.confirmSync" = false;
  "git.ignoreMissingGitWarning" = true;
  "git.mergeEditor" = true;

  "terminal.integrated.fontSize" = lib.mkForce 11;
  "terminal.integrated.shellIntegration.decorationsEnabled" = "never";

  "typescript.surveys.enabled" = false;

  "workbench.activityBar.location" = "hidden";
  "workbench.editor.decorations.badges" = true;
  "workbench.editor.decorations.colors" = true;
  "workbench.editor.revealIfOpen" = false;
  "workbench.iconTheme" = "file-icons";
  "workbench.startupEditor" = "newUntitledFile";
  "workbench.externalBrowser" = "firefox";

  "console-ninja.featureSet" = "Community";

  "commitollama.custom.model" = "deepseek-coder-v2:16b-lite-instruct-q8_0";
  "commitollama.model" = "Custom";

  "[css]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[html]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[javascript]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[json]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[jsonc]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[less]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[python]" = {"editor.defaultFormatter" = "ms-python.black-formatter";};
  "[ruby]" = {"editor.defaultFormatter" = "jnbt.vscode-rufo";};
  "[scss]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[typescript]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[typescriptreact]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[yaml]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
  "[markdown]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};

  "redhat.telemetry.enabled" = false;
  "solargraph.commandPath" = "${pkgs.solargraph}/bin/solargraph";

  "python.analysis.typeCheckingMode" = "strict";
  "python.analysis.autoImportCompletions" = true;
  "python.analysis.autoImportUserSymbols" = true;

  "nix.enableLanguageServer" = true;
  "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
  "nix.serverSettings" = {
    nixd = let
      flake = config.programs.nh.flake;
    in {
      formatting = {
        command = [
          "nixpkgs-fmt"
        ];
      };
      "nixpkgs" = {
        # expr = ''import <nixpkgs> {}''
        expr = ''import (builtins.getFlake "${flake}").inputs.nixpkgs {}'';
      };
      options = {
        nixos = {
          expr = ''(builtins.getFlake "${flake}").nixosConfigurations.desktop.options'';
        };
        home-manager = {
          expr = ''(builtins.getFlake "${flake}").homeConfigurations.${nixosConfig.defaults.username}.options'';
        };
      };
    };
  };

  "workbench.colorCustomizations" = {
    # https://code.visualstudio.com/api/references/theme-color
    "[Stylix]" = with nixosConfig.defaults.colorScheme.palette; {
      "activityBar.border" = "#${base02}";
      "checkbox.border" = "#${base02}";
      "commandCenter.border" = "#${base02}";
      "commandCenter.inactiveBorder" = "#${base02}";
      "editorWidget.border" = "#${base02}";
      "panel.border" = "#${base02}";
      "panelSection.border" = "#${base02}";
      "panelSectionHeader.border" = "#${base02}";
      "panelStickyScroll.border" = "#${base02}";
      "panelTitle.border" = "#${base02}";
      "sideBar.border" = "#${base02}";
      "statusBar.border" = "#${base02}";
      # "statusBar.background" = "#${base0E}";
      # "statusBar.foreground" = "#${base02}";
      # "statusBar.debuggingBorder" = "#${base02}";
      # "statusBar.noFolderBorder" = "#${base02}";
      "tab.border" = "#${base02}";
      "titleBar.border" = "#${base02}";
      "editorGroup.border" = "#${base02}";
      "editorGroupHeader.tabsBorder" = "#${base02}";
      "editorGroupHeader.border" = "#${base02}";
    };
  };

  "qalc.output.notation" = "auto";
  "qalc.output.precision" = 0;
  "qalc.output.lowerExponentBound" = -4;
  "terminal.integrated.stickyScroll.enabled" = false;
  "chat.editing.confirmEditRequestRemoval" = false;
  "github.copilot.nextEditSuggestions.enabled" = true;
  "github.copilot.chat.commitMessageGeneration.instructions" = [
    {
      text = lib.readFile ./instructions/commit.md;
    }
  ];
}
