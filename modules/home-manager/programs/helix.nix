{ pkgs
, lib
, ...
}: {
  programs.helix = {
    enable = true;

    languages = {
      language-server = {
        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = [ "--stdio" ];
        };

        solargraph = {
          command = lib.getExe pkgs.solargraph;
          args = [ "stdio" ];
        };

        typescript-language-server = {
          command = lib.getExe pkgs.typescript-language-server;
          args = [ "--stdio" ];
        };

        marksman = {
          command = lib.getExe pkgs.marksman;
          args = [ "--stdio" ];
        };

        jq-lsp = {
          command = lib.getExe pkgs.jq-lsp;
          args = [ "--stdio" ];
        };

        yaml-language-server = {
          command = lib.getExe pkgs.yaml-language-server;
          args = [ "--stdio" ];
        };

        rust-analyzer = {
          command = lib.getExe pkgs.rust-analyzer;
          args = [ "--stdio" ];
          config = {
            checkOnSave.command = "clippy";
            inlayHints.parameterHints.enable = true;
          };
        };

        nil = {
          command = lib.getExe pkgs.nil;
        };
      };

      language = [
        {
          name = "python";
          scope = "source.python";
          injection-regex = "py(thon)?";
          file-types = [ "py" "pyi" "py3" "pyw" ];
          shebangs = [ "python" "uv" ];
          comment-token = "#";
          language-servers = [ "pyright" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.ruff;
            args = [ "format" "--stdin-filename" "%{buffer_name}" "-" ];
          };
        }
        {
          name = "ruby";
          scope = "source.ruby";
          injection-regex = "ruby";
          file-types = [ "rb" "rake" "gemspec" ];
          shebangs = [ "ruby" ];
          comment-token = "#";
          language-servers = [ "solargraph" ];
        }
        {
          name = "nix";
          scope = "source.nix";
          injection-regex = "nix";
          file-types = [ "nix" ];
          shebangs = [ "nix-shell" ];
          comment-token = "#";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.nixpkgs-fmt;
          };
          language-servers = [ "nil" ];
        }

        {
          name = "toml";
          scope = "source.toml";
          injection-regex = "toml";
          file-types = [ "toml" ];
          comment-token = "#";
          auto-format = true;
        }

        {
          name = "javascript";
          scope = "source.js";
          injection-regex = "(js|javascript)";
          file-types = [ "js" "mjs" "cjs" ];
          shebangs = [ "node" ];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.prettier;
            args = [ "--stdin-filepath" "%{buffer_name}" "--parser" "babel" ];
          };
        }
        {
          name = "typescript";
          scope = "source.ts";
          injection-regex = "(ts|typescript)";
          file-types = [ "ts" "mts" "cts" ];
          shebangs = [ "deno" "bun" "ts-node" ];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.prettier;
            args = [ "--stdin-filepath" "%{buffer_name}" "--parser" "typescript" ];
          };
        }
        {
          name = "javascriptreact";
          scope = "source.jsx";
          injection-regex = "jsx";
          file-types = [ "jsx" ];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.prettier;
            args = [ "--stdin-filepath" "%{buffer_name}" "--parser" "babel" ];
          };
        }
        {
          name = "typescriptreact";
          scope = "source.tsx";
          injection-regex = "tsx";
          file-types = [ "tsx" ];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.prettier;
            args = [ "--stdin-filepath" "%{buffer_name}" "--parser" "typescript" ];
          };
        }
        {
          name = "markdown";
          scope = "source.md";
          injection-regex = "md|markdown";
          file-types = [ "md" "markdown" "mdx" ];
          block-comment-tokens = [
            {
              start = "<!--";
              end = "-->";
            }
          ];
          language-servers = [ "marksman" ];
        }
        {
          name = "json";
          scope = "source.json";
          injection-regex = "json";
          file-types = [ "json" "jsonl" "ipynb" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.prettier;
            args = [ "--stdin-filepath" "%{buffer_name}" "--parser" "json" ];
          };
        }
        {
          name = "jsonc";
          scope = "source.json";
          injection-regex = "jsonc";
          file-types = [ "jsonc" ];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.prettier;
            args = [ "--stdin-filepath" "%{buffer_name}" "--parser" "json" ];
          };
        }
        {
          name = "bash";
          scope = "source.bash";
          injection-regex = "(shell|bash|zsh|sh)";
          file-types = [ "sh" "bash" "zsh" "zshrc" ];
          shebangs = [ "sh" "bash" "dash" "zsh" ];
          comment-token = "#";
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.shfmt;
            args = [ "-fn" "-i" "2" "-ci" "-sr" ];
          };
        }
        {
          name = "yaml";
          scope = "source.yaml";
          injection-regex = "yml|yaml";
          file-types = [ "yml" "yaml" ];
          comment-token = "#";
          language-servers = [ "yaml-language-server" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.prettier;
            args = [ "--stdin-filepath" "%{buffer_name}" "--parser" "yaml" ];
          };
        }
        {
          name = "rust";
          scope = "source.rust";
          injection-regex = "rs|rust";
          file-types = [ "rs" ];
          shebangs = [ "rust-script" "cargo" ];
          comment-tokens = [ "//" "///" "//!" ];
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
            {
              start = "/**";
              end = "*/";
            }
            {
              start = "/*!";
              end = "*/";
            }
          ];
          language-servers = [ "rust-analyzer" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.rustfmt;
          };
        }
      ];
    };

    settings = {
      editor = {
        # VSCode-like appearance
        line-number = "relative";
        color-modes = true;
        bufferline = "multiple";
        mouse = true;
        middle-click-paste = true;
        scroll-lines = 3;
        scrolloff = 3;
        true-color = true;
        undercurl = true;

        # Auto-save and formatting (VSCode style)
        auto-pairs = true;
        auto-format = true;
        idle-timeout = 250;

        # Soft wrap (like VSCode word wrap)
        soft-wrap = {
          enable = true;
          max-wrap = 20;
          max-indent-retain = 0;
          wrap-indicator = "";
        };

        # Cursor shapes per mode
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        # Indent guides (VSCode style)
        indent-guides = {
          render = true;
          character = "│";
          skip-levels = 0;
        };

        # Whitespace rendering (optional, like VSCode render whitespace)
        whitespace = {
          render = "none";
          characters = {
            tab = "→";
            space = "·";
            newline = "⏎";
          };
        };

        # Diagnostics (inline like VSCode)
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "disable";
          prefix-len = 1;
        };

        # LSP settings
        lsp = {
          enable = true;
          display-messages = true;
          display-inlay-hints = true;
          auto-signature-help = true;
          snippets = true;
        };

        # File picker (VSCode-like)
        file-picker = {
          hidden = true;
          follow-symlinks = true;
          deduplicate-links = true;
          parents = true;
          ignore = true;
          git-ignore = true;
          git-global = true;
          git-exclude = true;
        };

        # Gutter layout (diff, diagnostics, line numbers)
        gutters = [ "diff" "diagnostics" "line-numbers" "spacer" ];

        # Auto-save on focus lost (VSCode style)
        auto-save = {
          focus-lost = true;
        };

        # Search settings (VSCode-like)
        search = {
          smart-case = true;
          wrap-around = true;
        };
      };

      keys =
        let
          shared = {
            # File operations
            "C-s" = ":write";

            # Undo/Redo 
            "C-z" = "undo";
            "C-S-z" = "redo";

            # Find/Replace
            "C-f" = "search";
            "C-S-f" = "global_search";

            # Copy/Paste 
            # Not working
            "C-c" = "yank_main_selection_to_clipboard";
            "C-v" = "paste_clipboard_after";
            "C-x" = [ "delete_selection" "yank_main_selection_to_clipboard" ];

            # Select all 
            "C-a" = "select_all";

            # Comment toggle
            "C-/" = "toggle_comments";
            # Block comment 
            "C-S-/" = "toggle_comments";

            # Format document
            "C-S-i" = ":format";

            # Word navigation
            "C-left" = "move_prev_word_start";
            "C-right" = "move_next_word_start";

            "C-backspace" = "delete_word_backward";
            "C-del" = "delete_word_forward";

            # Selection
            "C-S-left" = "extend_prev_word_start";
            "C-S-right" = "extend_next_word_start";

            # Line navigation
            "home" = "goto_line_start";
            "end" = "goto_line_end_newline";
            "C-g" = "goto_word";

            # Go to beginning/end of file
            "C-home" = "goto_file_start";
            "C-end" = "goto_last_line";

            # Page navigation
            "pageup" = "page_up";
            "pagedown" = "page_down";

            # Go to definition
            "C-d" = "goto_definition";

            # Duplicate line            
            "C-S-d" = [ "extend_to_line_bounds" "yank" "open_below" "replace_with_yanked" "collapse_selection" ];

            # Go to references
            "C-t" = "goto_reference";

            # Rename symbol
            "C-r" = "rename_symbol";

            # File picker / quick open
            "C-p" = "file_picker";
            # Command Palete
            "C-S-p" = "command_palette";

            # Delete line
            "S-del" = [ "extend_to_line_end" "delete_selection" ];

            # Indent/outdent
            "tab" = "indent";
            "S-tab" = "unindent";

            # Code action
            "C-." = "code_action";

            # Select all occurrences
            # not working
            "C-S-l" = [ "search_selection_detect_word_boundaries" "select_all" ];

            # Select current line
            "C-l" = "extend_line_below";

            # Close window 
            "C-w" = "wclose";

            # Split editor 
            "C-ret" = "vsplit";

            # Tab navigation
            "C-pageup" = "goto_previous_buffer";
            "C-pagedown" = "goto_next_buffer";
          };
        in
        {
          normal = shared // {
            "ret" = "insert_mode";
          };
          insert = {
            "esc" = "normal_mode";
          } // shared;

          select = {
            "esc" = "normal_mode";
          } // shared;
        };
    };
  };
}
