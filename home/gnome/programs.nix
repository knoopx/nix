{
  defaults,
  config,
  pkgs,
  ...
}: {
  programs = {
    vscode = {
      enable = true;
      package =
        pkgs.vscode.override
        {
          commandLineArgs = [
            "--disable-features=WaylandFractionalScaleV1"
          ];
        };

      keybindings = [
        {
          key = "shift+delete";
          command = "editor.action.deleteLines";
          when = "textInputFocus && !editorReadonly";
        }
        {
          key = "ctrl+k j";
          command = "terminal.focus";
        }
        {
          key = "ctrl+r";
          command = "-workbench.action.reloadWindow";
          when = "isDevelopment";
        }
        {
          key = "ctrl+r";
          command = "-python.refreshTensorBoard";
          when = "python.hasActiveTensorBoardSession";
        }
        {
          key = "ctrl+r";
          command = "-workbench.action.quickOpenNavigateNextInRecentFilesPicker";
          when = "inQuickOpen && inRecentFilesPicker";
        }
        {
          key = "ctrl+m";
          command = "-editor.action.toggleTabFocusMode";
        }
        {
          key = "ctrl+k u";
          command = "workbench.action.focusActiveEditorGroup";
        }
        {
          "key" = "ctrl+l";
          "command" = "-continue.focusContinueInput";
        }
      ];

      userSettings = {
        "extensions.ignoreRecommendations" = true;
        "terminal.integrated.enableImages" = true;
        "terminal.integrated.enableMultiLinePasteWarning" = false;
        "terminal.integrated.env.linux" = {};
        "security.workspace.trust.enabled" = false;
        "window.titleBarStyle" = "custom";

        "diffEditor.ignoreTrimWhitespace" = true;
        "editor.fontLigatures" = true;
        "editor.fontSize" = 12;
        "editor.formatOnSaveMode" = "file";
        "editor.inlineSuggest.enabled" = true;
        "editor.multiCursorModifier" = "ctrlCmd";
        "editor.scrollBeyondLastLine" = false;
        "editor.semanticHighlighting.enabled" = true;
        "editor.suggestSelection" = "first";
        "editor.wordWrap" = "off";

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

        "terminal.integrated.fontSize" = 11;
        "terminal.integrated.shellIntegration.decorationsEnabled" = "never";

        "typescript.surveys.enabled" = false;

        "workbench.editor.decorations.badges" = true;
        "workbench.editor.decorations.colors" = true;
        "workbench.editor.revealIfOpen" = false;
        "workbench.iconTheme" = "file-icons";
        "workbench.startupEditor" = "newUntitledFile";

        "console-ninja.featureSet" = "Community";

        "commitollama.model" = "custom";
        "commitollama.custom.model" = "deepseek-coder-v2:16b-lite-instruct-q8_0";

        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[scss]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
        };
        "[ruby]" = {
          "editor.defaultFormatter" = "jnbt.vscode-rufo";
        };
        "redhat.telemetry.enabled" = false;

        "solargraph.commandPath" = "${pkgs.solargraph}/bin/solargraph";

        "python.analysis.typeCheckingMode" = "basic";
        "python.analysis.autoImportCompletions" = true;
        "python.analysis.autoImportUserSymbols" = true;

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.serverSettings" = {
          nixd = let
            flake = "${config.home.homeDirectory}/.dotfiles";
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
                expr = ''(builtins.getFlake "${flake}").homeConfigurations.${defaults.username}.options'';
              };
            };
          };
        };

        "workbench.colorCustomizations" = {
          "[Stylix]" = {
          };
        };

        "qalc.output.notation" = "auto";
        "qalc.output.lowerExponentBound" = -4;
      };
    };

    fish = {
      enable = true;

      # bind \cf __fzf_find_file
      # bind \co __fzf_open
      # bind \cr __fzf_reverse_isearch

      # bind \cs fzf-launcher
      # bind \es fzf-silverbullet # alt-s
      # bind \ew yazi # alt-w
      shellAliases = {
        ollamark = "$HOME/Projects/knoopx/ollamark/src/ollamark.tsx";
        codestral = "ollamark -t 0.3 --model codestral";
        nemo = "ollamark -t 0.3 --model mistral-nemo";
        llama3 = "ollamark -t 0.3 --model llama3";
      };

      shellAbbrs = {
        ns = "nix-shell --command fish";
        nu = "nh os switch -u ~/.dotfiles/";
        dc = "docker-compose";
        ls = "eza -lah";
        pbpaste = "fish_clipboard_paste";
        pbcopy = "fish_clipboard_copy";
      };

      interactiveShellInit = ''
        set fish_greeting

        set -gx OPENAI_API_BASE "http://127.0.0.1:11434/v1"
        set -gx OPENAI_API_KEY ollama

        set -px --path PATH "$HOME/bin/"
        set -px --path PATH "$HOME/.local/bin/"
        set -px --path PATH "$HOME/.bun/bin"
        set -px --path PATH "$HOME/.cargo/bin:$PATH"
        set -px --path PATH "$HOME/go/bin:$PATH"
        set -px --path PATH "$HOME/.local/share/gem/ruby/3.1.0/bin/:$PATH"
        set -px --path PATH "/etc/profiles/per-user/$USER/bin/:$PATH"
        set -x LD_LIBRARY_PATH "/run/opengl-driver/lib/:$NIX_LD_LIBRARY_PATH"
        set -gx TRITON_LIBCUDA_PATH /run/opengl-driver/lib/
      '';
    };

    chromium = {
      enable = false;
      package = pkgs.chromium.override {
        commandLineArgs = [
          # "--disable-features=WaylandFractionalScaleV1"
          "--hide-crashed-bubble"
          "--hide-fullscreen-exit-ui"
          "--hide-sidepanel-button"
          "--remove-tabsearch-button"
          "--show-avatar-button=never"
          "--force-dark-mode"
          "--no-default-browser-check"
          "--gtk-version=4"
          "--enable-gpu-rasterization"
          "--enable-oop-rasterization"
          "--enable-zero-copy"
          "--ignore-gpu-blocklist"
          "--enable-features=VaapiVideoDecoder"
          "--password-store=gnome"
          "--enable-hardware-overlays"
          "--hide-tab-close-buttons"
          "--remove-grab-handle"
          "--remove-tabsearch-button"
        ];
      };

      extensions = [
        "chklaanhfefbnpoihckbnefhakgolnmc" # JSONView
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
        "opokoaglpekkimldnlggpoagmjegichg" # ViolentMonkey
        # {
        #   id = "dcpihecpambacapedldabdbpakmachpb";
        #   # updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
        # }
      ];

      dictionaries = [
        pkgs.hunspellDictsChromium.en_US
      ];

      # homepageLocation = "about:blank";
      # browserConfig = {
      #   CloudPrintSubmitEnabled = false;
      #   EnableMediaRouter = false;
      #   HideWebStoreIcon = true;
      #   MetricsReportingEnabled = false;
      #   NewTabPageLocation = "about:blank";
      #   PasswordManagerEnabled = true;
      #   RestoreOnStartup = 1; # 5 = Open New Tab Page 1 = Restore the last session 4 = Open a list of URLs
      #   SpellcheckEnabled = true;
      #   SpellcheckLanguage = ["lt" "en-US"];
      #   WelcomePageOnOSUpgradeEnabled = false;
      # };
    };

    kitty = {
      enable = true;

      settings = {
        active_tab_font_style = "bold";
        confirm_os_window_close = 0;
        cursor_shape = "block";
        font_size = 10;
        hide_window_decorations = "yes";
        tab_bar_edge = "top";
        tab_bar_margin_width = 5;
        tab_bar_style = "separator";
        window_padding_width = 10;
      };

      extraConfig = with defaults.colorScheme.palette; ''
        tab_separator " "
        tab_title_template " {fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title} "
        active_tab_foreground #${base00}
        active_tab_background #${base0E}
        inactive_tab_background #${base00}
        tab_bar_background #${base00}
      '';
    };
  };
}
