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
          config = {};
        };

        solargraph.config = {
          diagnostics = true;
          formatting = true;
        };

        typescript-language-server = {
          command = lib.getExe pkgs.typescript-language-server;
          args = ["--stdio"];
          config = {};
        };
      };
      language = [
        {
          name = "python";
          language-servers = ["pyright"];
        }
        {
          name = "ruby";
          language-servers = ["solargraph"];
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "nixpkgs-fmt";
        }

        {
          name = "toml";
          auto-format = true;
        }

        {
          name = "javascript";
          language-servers = ["typescript-language-server"];
        }
        {
          name = "typescript";
          language-servers = ["typescript-language-server"];
        }
      ];
    };

    settings = {
      editor.color-modes = true;
      editor.idle-timeout = 100;
      editor.soft-wrap.enable = true;
      editor.true-color = true;

      editor = {
        scrolloff = 10;

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        indent-guides = {
          render = true;
          character = "│";
          skip-levels = 0;
        };

        end-of-line-diagnostics = "hint";
        inline-diagnostics = {cursor-line = "error";};
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };

      # VSCode-like keybindings
      keys.normal = {
        # File operations (Ctrl+S = save)
        "C-s" = ":write";
        "C-S-s" = ":write";

        # Undo/Redo (Ctrl+Z = undo, Ctrl+Shift+Z = redo)
        "C-z" = "undo";
        "C-S-z" = "redo";

        # Find (Ctrl+F = search)
        "C-f" = "search";

        # Go to line (Ctrl+G)
        "C-g" = "goto_line";

        # Copy/Paste (Ctrl+C = yank, Ctrl+V = paste)
        "C-c" = "yank_main_selection_to_clipboard";
        "C-v" = "paste_clipboard_after";

        # Select all (Ctrl+A)
        "C-a" = "select_all";

        # Comment toggle (Ctrl+/)
        "C-/" = "toggle_comments";

        # Format selection
        "C-S-f" = "format_selections";

        # Word navigation (Ctrl+Left/Right)
        "C-left" = "move_prev_word_start";
        "C-right" = "move_next_word_start";

        # Line navigation (Ctrl+Up/Down)
        "C-up" = "goto_line_start";
        "C-down" = "goto_line_end";

        # Go to beginning/end of file (Ctrl+Home/End)
        "C-home" = "goto_file_start";
        "C-end" = "goto_file_end";

        # Close window (Ctrl+W)
        "C-w" = {q = "wclose";};

        # Tab navigation (Ctrl+Tab = next buffer, Ctrl+Shift+Tab = prev buffer)
        "C-tab" = "goto_next_buffer";
        "C-S-tab" = "goto_previous_buffer";
      };

      keys.insert = {
        # Exit insert mode with Escape or Ctrl+[ (vscode style)
        "C-[" = "normal_mode";

        # Undo/Redo in insert mode
        "C-z" = "undo";
        "C-S-z" = "redo";

        # Word deletion (Ctrl+Backspace = delete word backward, Ctrl+Delete = delete word forward)
        "C-backspace" = "delete_word_backward";
        "C-del" = "delete_word_forward";

        # Line deletion (Ctrl+K = delete to end of line)
        "C-k" = "kill_to_line_end";

        # Move to line start/end (Ctrl+A = start, Ctrl+E = end)
        "C-a" = "goto_line_start";
        "C-e" = "goto_line_end";

        # Copy/Paste in insert mode
        "C-c" = "normal_mode";
        "C-v" = "paste_clipboard_after";

        # Select all in insert mode (Ctrl+Shift+A)
        "C-S-a" = "select_all";
      };

      keys.select = {
        # Copy/Paste in select mode
        "C-c" = "yank_main_selection_to_clipboard";
        "C-v" = "paste_clipboard_after";

        # Exit select mode
        "C-[" = "normal_mode";
      };
    };
  };
}
