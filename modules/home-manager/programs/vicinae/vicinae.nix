{
  inputs,
  config,
  nixosConfig,
  ...
}: {
  stylix.targets.vicinae.enable = false;

  # home.file."${config.xdg.dataHome}/vicinae/scripts" = {
  #   source = ./scripts;
  #   recursive = true;
  # };

  programs.vicinae = {
    enable = true;
    systemd.enable = true;

    extensions = map (name:
      config.lib.vicinae.mkExtension {
        name = name;
        src = inputs.vicinae-extensions + "/extensions/${name}";
      }) [
      "bluetooth"
      # "brotab"
      # "dbus"
      "firefox"
      "niri"
      "nix"
      "otp"
      "podman"
      "port-killer"
      "power-profile"
      "process-manager"
      "rodalies"
      "screen-recordings"
      "skate"
      "stocks"
      "supergenpass"
      "github"
      # "systemd"
      "tmux"
      "himalaya"
      # "jujutsu"

      # "can-i-use"
      # "cheatsheets"
      # "cloudflare"
      # "devdocs"
      # "duckduckgo-image-search"
      # "gif-search"
      # "github-trending"
      # "google-fonts"
      # "hacker-news"
      # "homeassistant"
      # "kill-process"
      # "knowyourmeme"
      # "meme-generator"
      # "notion"
      # "plex"
      # "raycast-ollama"
      # "reddit-search"
      # "regex-tester"
      # "remove-paywall"
      # "rhttp"
      # "tailwindcss"
      # "thingiverse"
      # "translate"
      # "weather"
      # "wikipedia"
    ];

    settings = {
      imports = [];
      search_files_in_root = false;
      escape_key_behavior = "navigate_back";
      close_on_focus_loss = false;
      consider_preedit = false;
      pop_to_root_on_close = false;
      favicon_service = "google";
      keybinding = "default";
      font = {
        normal = {
          family = "auto";
          size = 10;
        };
      };
      theme = {
        light = {
          name = "custom";
          icon_theme = config.gtk.iconTheme.name;
        };
        dark = {
          name = "custom";
          icon_theme = config.gtk.iconTheme.name;
        };
      };
      providers = {
        files = {
          enabled = false;
          preferences = {
            autoIndexing = false;
          };
        };
        "@brpaz/store.raycast.brotab" = {
          preferences = {
            brotabPath = "";
          };
        };
        "@knoopx/store.vicinae.silverbullet" = {
          preferences = {
            silverbulletApiUrl = "https://wiki.knoopx.net";
          };
        };
        "@leiserfg/store.raycast.ssh" = {
          preferences = {
            terminal = "wezterm";
          };
        };
        "@knoopx/store.vicinae.stocks" = {
          preferences = {
            symbols = "NVDA,NET,MSFT,AMZN,XPEV,BABA,BTC-USD";
          };
        };
        "@knoopx/store.vicinae.tmux" = {
          preferences = {
            terminalCommand = "wezterm";
            terminalArgs = "start --";
          };
        };
      };
      launcher_window = {
        opacity = 1;
        blur = {
          enabled = true;
        };
        dim_around = true;
        client_side_decorations = {
          enabled = true;
          rounding = 8;
          border_width = 3;
        };
        compact_mode = {
          enabled = false;
        };
        size = {
          width = 800;
          height = 600;
        };
        screen = "auto";
        layer_shell = {
          enabled = false;
          keyboard_interactivity = "exclusive";
          layer = "top";
        };
      };
      keybinds = {
        "open-search-filter" = "control+P";
        "open-settings" = "control+,";
        "toggle-action-panel" = "control+J";
        "action.copy" = "control+shift+C";
        "action.copy-name" = "control+shift+.";
        "action.copy-path" = "control+shift+,";
        "action.dangerous-remove" = "control+shift+X";
        "action.duplicate" = "control+D";
        "action.edit" = "control+E";
        "action.edit-secondary" = "control+shift+E";
        "action.move-down" = "control+shift+ARROWDOWN";
        "action.move-up" = "control+shift+ARROWUP";
        "action.new" = "control+N";
        "action.open" = "control+O";
        "action.pin" = "control+shift+P";
        "action.refresh" = "control+R";
        "action.remove" = "control+X";
        "action.save" = "control+S";
      };
    };
  };

  home.file.".local/bin/vjj".source = inputs.vicinae-extensions + "/extensions/jujutsu/vjj.nu";
  home.file.".local/bin/vjj".executable = true;

  home.file.".local/share/vicinae/themes/custom.toml".text = ''
    [meta]
    version = 1
    name = "Custom Theme"
    description = "Custom Theme"
    variant = "dark"
    inherits = "vicinae-dark"

    [colors.core]
    accent = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
    accent_foreground = "#${nixosConfig.defaults.colorScheme.palette.base00}"
    background = "#${nixosConfig.defaults.colorScheme.palette.base00}"
    foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}"
    secondary_background = "#${nixosConfig.defaults.colorScheme.palette.base01}"
    border = "#${nixosConfig.defaults.colorScheme.palette.base02}"

    [colors.accents]
    blue = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
    green = "#${nixosConfig.defaults.colorScheme.palette.base0B}"
    magenta = "#${nixosConfig.defaults.colorScheme.palette.base0F}"
    orange = "#${nixosConfig.defaults.colorScheme.palette.base09}"
    purple = "#${nixosConfig.defaults.colorScheme.palette.base0E}"
    red = "#${nixosConfig.defaults.colorScheme.palette.base08}"
    yellow = "#${nixosConfig.defaults.colorScheme.palette.base0A}"
    cyan = "#${nixosConfig.defaults.colorScheme.palette.base0C}"

    [colors.text]
    default = "#${nixosConfig.defaults.colorScheme.palette.base05}"
    muted = "#${nixosConfig.defaults.colorScheme.palette.base04}"
    danger = "#${nixosConfig.defaults.colorScheme.palette.base08}"
    success = "#${nixosConfig.defaults.colorScheme.palette.base0B}"
    placeholder = "#${nixosConfig.defaults.colorScheme.palette.base03}"
    selection = { background = "#${nixosConfig.defaults.colorScheme.palette.base0D}", foreground = "#${nixosConfig.defaults.colorScheme.palette.base00}" }

    [colors.text.links]
    default = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
    visited = "#${nixosConfig.defaults.colorScheme.palette.base0F}"

    [colors.input]
    border = "#${nixosConfig.defaults.colorScheme.palette.base02}"
    border_focus = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
    border_error = "#${nixosConfig.defaults.colorScheme.palette.base08}"

    [colors.button.primary]
    background = "#${nixosConfig.defaults.colorScheme.palette.base02}"
    foreground = "#${nixosConfig.defaults.colorScheme.palette.base00}"
    hover = { background = "#${nixosConfig.defaults.colorScheme.palette.base03}" }
    focus = { outline = "#${nixosConfig.defaults.colorScheme.palette.base0D}" }

    [colors.list.item.hover]
    background = "#${nixosConfig.defaults.colorScheme.palette.base02}"
    foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}"

    [colors.list.item.selection]
    background = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
    foreground = "#${nixosConfig.defaults.colorScheme.palette.base00}"
    secondary_background = "#${nixosConfig.defaults.colorScheme.palette.base02}"
    secondary_foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}"

    [colors.grid.item]
    background = "#${nixosConfig.defaults.colorScheme.palette.base01}"
    hover = { outline = "#${nixosConfig.defaults.colorScheme.palette.base05}" }
    selection = { outline = "#${nixosConfig.defaults.colorScheme.palette.base0D}" }

    [colors.scrollbars]
    background = "#${nixosConfig.defaults.colorScheme.palette.base02}"

    [colors.main_window]
    border = "#${nixosConfig.defaults.colorScheme.palette.base02}"

    [colors.settings_window]
    border = "#${nixosConfig.defaults.colorScheme.palette.base02}"

    [colors.loading]
    bar = "#${nixosConfig.defaults.colorScheme.palette.base05}"
    spinner = "#${nixosConfig.defaults.colorScheme.palette.base05}"
  '';
}
