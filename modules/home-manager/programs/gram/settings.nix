{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  settings = builtins.toJSON {
    ui_font_size = 13;
    buffer_font_size = 13;
    buffer_font_family = "JetBrainsMono Nerd Font";
    ui_font_weight = 400;
    buffer_font_weight = 300;
    buffer_line_height = "standard";

    terminal = {
      font_size = 11;
      font_weight = 100;
      line_height = "standard";
    };

    features = {};

    theme = {
      mode = "dark";
      dark = "Base16 custom";
      light = "Base16 custom";
    };
    base_keymap = "VSCode";
    vim_mode = false;

    session = {
      restore_unsaved_buffers = false;
    };

    toolbar = {
      code_actions = true;
      breadcrumbs = true;
    };

    minimap = {
      max_width_columns = 80;
      thumb = "always";
      show = "always";
    };

    git_panel = {
      button = false;
    };

    git.inline_blame.enabled = true;

    project_panel = {
      starts_open = false;
      auto_fold_dirs = true;
    };

    title_bar = {
      show_menus = false;
      show_branch_icon = false;
    };

    tabs = {
      file_icons = true;
      git_status = true;
      show_close_button = "hidden";
    };

    prettier = {
      allowed = true;
    };

    lsp = {
      tailwindcss-language-server.binary.allow_binary_download = true;
      node.allow_binary_download = true;
      eslint.binary.allow_binary_download = true;
      vtsls.binary.allow_binary_download = true;
      package-version-server.binary.allow_binary_download = true;
      json-language-server.binary.allow_binary_download = true;
      nixd.binary.allow_binary_download = true;
      typescript-language-server.binary.allow_binary_download = true;
    };

    languages = {
      # Nix
      Nix = {
        language_servers = ["nixd"];
        formatter = {
          external = {
            command = "alejandra";
          };
        };
      };

      # Python
      Python = {
        language_servers = ["pyright"];
        formatter = {
          external = {
            command = "black";
          };
        };
      };

      # Ruby
      Ruby = {
        language_servers = ["ruby-lsp"];
        formatter = {
          external = {
            command = "rufo";
          };
        };
      };

      # JavaScript / TypeScript
      JavaScript = {
        language_servers = ["typescript-language-server"];
      };

      TypeScript = {
        language_servers = ["typescript-language-server"];
      };

      # Rust
      Rust = {
        language_servers = ["rust-analyzer"];
      };

      # TOML
      TOML = {
        language_servers = ["marksman"];
      };

      # JSON
      JSON = {
        language_servers = ["json-language-server"];
      };

      # CSS / PostCSS
      CSS = {
        language_servers = ["tailwindcss-language-server"];
      };

      # HTML
      HTML = {
        language_servers = ["tailwindcss-language-server"];
      };

      # Markdown
      Markdown = {
        language_servers = ["marksman"];
      };
    };
  };
in {
  xdg.configFile."gram/settings.jsonc".text = settings;
}
