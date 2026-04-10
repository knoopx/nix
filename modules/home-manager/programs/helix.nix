{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;

    languages = {
      language-server = {
        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = ["--stdio"];
        };

        solargraph = {
          command = lib.getExe pkgs.solargraph;
          args = ["stdio"];
        };

        typescript-language-server = {
          command = lib.getExe pkgs.typescript-language-server;
          args = ["--stdio"];
        };

        marksman = {
          command = "marksman";
          args = ["--stdio"];
        };

        jq-lsp = {
          command = lib.getExe pkgs.jq-lsp;
          args = ["--stdio"];
        };

        yaml-language-server = {
          command = lib.getExe pkgs.yaml-language-server;
          args = ["--stdio"];
        };

        rust-analyzer = {
          command = lib.getExe pkgs.rust-analyzer;
          args = ["--stdio"];
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
          file-types = ["py" "pyi" "py3" "pyw"];
          shebangs = ["python" "uv"];
          comment-token = "#";
          language-servers = ["pyright"];
          auto-format = true;
          formatter = {
            command = "ruff";
            args = ["format" "--stdin-filename" "%{buffer_name}" "-"];
          };
        }
        {
          name = "ruby";
          scope = "source.ruby";
          injection-regex = "ruby";
          file-types = ["rb" "rake" "gemspec"];
          shebangs = ["ruby"];
          comment-token = "#";
          language-servers = ["solargraph"];
        }
        {
          name = "nix";
          scope = "source.nix";
          injection-regex = "nix";
          file-types = ["nix"];
          shebangs = ["nix-shell"];
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
          language-servers = ["nil"];
        }

        {
          name = "toml";
          scope = "source.toml";
          injection-regex = "toml";
          file-types = ["toml"];
          comment-token = "#";
          auto-format = true;
        }

        {
          name = "javascript";
          scope = "source.js";
          injection-regex = "(js|javascript)";
          file-types = ["js" "mjs" "cjs"];
          shebangs = ["node"];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          language-servers = ["typescript-language-server"];
          auto-format = true;
        }
        {
          name = "typescript";
          scope = "source.ts";
          injection-regex = "(ts|typescript)";
          file-types = ["ts" "mts" "cts"];
          shebangs = ["deno" "bun" "ts-node"];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          language-servers = ["typescript-language-server"];
          auto-format = true;
        }
        {
          name = "javascriptreact";
          scope = "source.jsx";
          injection-regex = "jsx";
          file-types = ["jsx"];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          language-servers = ["typescript-language-server"];
          auto-format = true;
        }
        {
          name = "typescriptreact";
          scope = "source.tsx";
          injection-regex = "tsx";
          file-types = ["tsx"];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          language-servers = ["typescript-language-server"];
          auto-format = true;
        }
        {
          name = "markdown";
          scope = "source.md";
          injection-regex = "md|markdown";
          file-types = ["md" "markdown" "mdx"];
          block-comment-tokens = [
            {
              start = "<!--";
              end = "-->";
            }
          ];
          language-servers = ["marksman"];
        }
        {
          name = "json";
          scope = "source.json";
          injection-regex = "json";
          file-types = ["json" "jsonl" "ipynb"];
          auto-format = true;
        }
        {
          name = "jsonc";
          scope = "source.json";
          injection-regex = "jsonc";
          file-types = ["jsonc"];
          comment-token = "//";
          block-comment-tokens = [
            {
              start = "/*";
              end = "*/";
            }
          ];
          auto-format = true;
        }
        {
          name = "bash";
          scope = "source.bash";
          injection-regex = "(shell|bash|zsh|sh)";
          file-types = ["sh" "bash" "zsh" "zshrc"];
          shebangs = ["sh" "bash" "dash" "zsh"];
          comment-token = "#";
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.shfmt;
            args = ["-fn" "-i" "2" "-ci" "-sr"];
          };
        }
        {
          name = "yaml";
          scope = "source.yaml";
          injection-regex = "yml|yaml";
          file-types = ["yml" "yaml"];
          comment-token = "#";
          language-servers = ["yaml-language-server"];
          auto-format = true;
        }
        {
          name = "rust";
          scope = "source.rust";
          injection-regex = "rs|rust";
          file-types = ["rs"];
          shebangs = ["rust-script" "cargo"];
          comment-tokens = ["//" "///" "//!"];
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
          language-servers = ["rust-analyzer"];
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
        gutters = ["diff" "diagnostics" "line-numbers" "spacer"];

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

      # VSCode-like keybindings
      keys.normal = {
        # File operations (Ctrl+S = save, Ctrl+Shift+S = save all/as)
        "C-s" = ":write";
        "C-S-s" = ":wq";

        # Undo/Redo (Ctrl+Z = undo, Ctrl+Y = redo - VSCode style)
        "C-z" = "undo";
        "C-y" = "redo";

        # Find/Replace (Ctrl+F = find)
        "C-f" = "search";

        # Go to line (Ctrl+G)
        "C-g" = "goto_line";

        # Copy/Paste (Ctrl+C = yank, Ctrl+V = paste, Ctrl+X = cut)
        "C-c" = "yank_main_selection_to_clipboard";
        "C-v" = "paste_clipboard_after";
        "C-x" = ["delete_selection" "yank_main_selection_to_clipboard"];

        # Select all (Ctrl+A)
        "C-a" = "select_all";

        # Comment toggle (Ctrl+/)
        "C-/" = "toggle_comments";

        # Block comment (Ctrl+Shift+A)
        "C-S-a" = "toggle_comments";

        # Format document (Ctrl+Shift+I) and selection (Ctrl+K Ctrl+F)
        "C-S-i" = "format_selections";
        "C-k" = {f = "format_selections";};

        # Word navigation (Ctrl+Left/Right)
        "C-left" = "move_prev_word_start";
        "C-right" = "move_next_word_start";

        # Line navigation (Home/End)
        "home" = "goto_line_start";
        "end" = "goto_line_end";

        # Go to beginning/end of file (Ctrl+Home/End)
        "C-home" = "goto_file_start";
        "C-end" = "goto_last_line";

        # Page navigation (PageUp/PageDown)
        "pageup" = "page_up";
        "pagedown" = "page_down";

        # Delete line (Ctrl+Shift+K) - select line bounds then delete
        "C-S-k" = ["extend_to_line_bounds" "delete_selection"];

        # Insert line above (Ctrl+O - VSCode style)
        "C-o" = "open_above";

        # Copy line up/down
        "C-S-A-up" = "move_line_up";
        "C-S-A-down" = "move_line_down";

        # Indent/outdent (Ctrl+]/Ctrl+[)
        "C-]" = "indent";
        "C-[" = "unindent";

        # Jump to bracket (Ctrl+Shift+\)
        "C-S-_" = "match_brackets";

        # Quick actions (Ctrl+. = quick fix)
        "C-." = "goto_next_diag";

        # Select all occurrences (Ctrl+Shift+L)
        "C-S-l" = ["search_selection_detect_word_boundaries" "select_all"];

        # Select current line (Ctrl+L)
        "C-l" = "extend_line_below";

        # Close window (Ctrl+W)
        "C-w" = {q = "wclose";};

        # Split editor (Ctrl+\\)
        "C-_" = "vsplit";

        # Tab navigation (Ctrl+Tab = next buffer, Ctrl+Shift+Tab = prev buffer)
        "C-tab" = "goto_next_buffer";
        "C-S-tab" = "goto_previous_buffer";

        # Command palette (Ctrl+Shift+P)
        "C-S-p" = "command_mode";

        # Settings (Ctrl+,)
        "C-," = "command_mode";
      };

      keys.insert = {
        # Exit insert mode with Escape or Ctrl+[ (vscode style)
        "esc" = "normal_mode";
        "C-[" = "normal_mode";

        # Undo/Redo in insert mode (Ctrl+Z/Ctrl+Y)
        "C-z" = "undo";
        "C-y" = "redo";

        # Word navigation (Ctrl+Left/Right) - VSCode style
        "C-left" = "move_prev_word_start";
        "C-right" = "move_next_word_start";

        # Word deletion (Ctrl+Backspace = delete word backward, Ctrl+Delete = delete word forward)
        "C-backspace" = "delete_word_backward";
        "C-del" = "delete_word_forward";

        # Line deletion (Ctrl+K = delete to end of line)
        "C-k" = "kill_to_line_end";

        # Move to line start/end (Ctrl+A = start, Ctrl+E = end)
        "C-a" = "goto_line_start";
        "C-e" = "goto_line_end";

        # Copy/Paste in insert mode (Ctrl+C = copy, Ctrl+V = paste)
        "C-c" = "yank_main_selection_to_clipboard";
        "C-v" = "paste_clipboard_after";

        # Trigger completions (Ctrl+x) - manual trigger, automatic by default
        "C-x" = "completion";

        # Quick fix (Ctrl+.)
        "C-." = "goto_next_diag";

        # Accept suggestion (Tab) - triggers completions if menu is open, otherwise inserts tab
        "tab" = "completion";

        # Delete to end of line (Shift+Delete)
        "S-del" = "kill_to_line_end";
      };

      keys.select = {
        # Delete line (Shift+Delete)
        "S-del" = ["extend_to_line_bounds" "delete_selection"];

        # Copy/Paste in select mode
        "C-c" = "yank_main_selection_to_clipboard";
        "C-v" = "paste_clipboard_after";
        "C-x" = ["delete_selection" "yank_main_selection_to_clipboard"];

        # Exit select mode
        "esc" = "normal_mode";
        "C-[" = "normal_mode";

        # Jump to bracket (Ctrl+Shift+\)
        "C-S-_" = "match_brackets";
      };
    };
  };
}
