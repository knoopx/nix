{
  inputs,
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: let
  browserDesktopEntry = nixosConfig.defaults.apps.browser.desktopEntry;
  shortcuts = [
    {
      name = "Slack";
      icon = "icon://favicon/app.slack.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
      url = "https://app.slack.com/client/T069GEHD6AC/C09JKJ3HL4X";
      app = browserDesktopEntry;
    }
    {
      name = "Telegram";
      icon = "icon://favicon/web.telegram.org?fallback=icon://omnicast/image?fill%3Dprimary-text";
      url = "https://web.telegram.org/k/";
      app = browserDesktopEntry;
    }
    {
      name = "Discord";
      icon = "icon://omnicast/discord";
      url = "https://discord.com/channels/";
      app = browserDesktopEntry;
    }
    {
      name = "Youtube";
      icon = "icon://favicon/www.youtube.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
      url = "https://www.youtube.com/";
      app = browserDesktopEntry;
    }
    {
      name = "Reddit";
      icon = "icon://favicon/www.reddit.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
      url = "https://www.reddit.com/";
      app = browserDesktopEntry;
    }
    {
      name = "WhatsApp";
      icon = "icon://omnicast/speech-bubble-active?fill=primary-text";
      url = "https://web.whatsapp.com/";
      app = browserDesktopEntry;
    }
    {
      name = "Spotify";
      icon = "icon://favicon/open.spotify.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
      url = "https://open.spotify.com/";
      app = browserDesktopEntry;
    }
    {
      name = "Plex Web";
      icon = "icon://favicon/app.plex.tv?fallback=icon://omnicast/image?fill%3Dprimary-text";
      url = "https://app.plex.tv/desktop/";
      app = browserDesktopEntry;
    }
    {
      name = "Webull";
      icon = "icon://favicon/app.webull.com?fallback=icon://omnicast/image?fill%3Dprimary-text";
      url = "https://app.webull.com/stocks";
      app = browserDesktopEntry;
    }
  ];
in {
  stylix.targets.vicinae.enable = false;

  home.file."${config.xdg.dataHome}/vicinae/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix/modules/home-manager/programs/vicinae/scripts";

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
      # "home-assistant"
      # "systemd"
      "tmux"
      # "gog"
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
      "$schema" = "https://vicinae.com/schemas/config.json";
      imports = [];
      close_on_focus_loss = false;
      consider_preedit = false;
      pop_to_root_on_close = false;
      escape_key_behavior = "navigate_back";
      favicon_service = "google";
      keybinding = "default";
      search_files_in_root = false;
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
      launcher_window = {
        opacity = 1;
        client_side_decorations = {
          enabled = true;
          rounding = 8;
          border_width = 3;
        };
        size = {
          width = 800;
          height = 600;
        };
        dim_around = true;
        blur = {
          enabled = false;
        };
        compact_mode = {
          enabled = false;
        };
        layer_shell = {
          layer = "top";
          keyboard_interactivity = "exclusive";
          enabled = false;
        };
      };
      keybinds = {
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
        "open-search-filter" = "control+P";
        "open-settings" = "control+,";
        "toggle-action-panel" = "control+J";
      };
      providers = {
        "@brpaz/store.raycast.brotab" = {
          preferences = {
            brotabPath = "/etc/profiles/per-user/${nixosConfig.defaults.username}/bin/brotab";
          };
        };
        "@knoopx/home-assistant" = {
          preferences = {
            url = "https://home.knoopx.net";
          };
        };
        "@knoopx/store.vicinae.silverbullet" = {
          preferences = {
            silverbulletApiUrl = "https://wiki.knoopx.net";
          };
        };
        "@knoopx/store.vicinae.stocks" = {
          preferences = {
            symbols = "NVDA,NET,MSFT,AMZN,XPEV,BABA,BTC-USD";
          };
        };
        "@knoopx/store.vicinae.tmux" = {
          preferences = {
            terminalArgs = "start --";
            terminalCommand = "wezterm";
          };
        };
        "@leiserfg/store.raycast.ssh" = {
          preferences = {
            terminal = "wezterm";
          };
        };
        files = {
          enabled = false;
          preferences = {
            autoIndexing = false;
          };
        };
      };
    };
  };

  systemd.user.services.vicinae.Service.ExecStartPre = let
    shortcutsJson = pkgs.writeText "vicinae-shortcuts.json" (builtins.toJSON shortcuts);
  in [
    (pkgs.writeShellScript "vicinae-sync-shortcuts" ''
      if [ -f "${config.xdg.dataHome}/vicinae/vicinae.db" ]; then
        export PATH="${lib.makeBinPath [pkgs.coreutils pkgs.nushell pkgs.sqlite]}:$PATH"
        ${lib.getExe pkgs.nushell} -c --stdin <<NU
        let vicinaedb = (realpath ~/.local/share/vicinae/vicinae.db)
        sqlite3 $vicinaedb "DELETE FROM shortcut;"
        open ${shortcutsJson} | each {
          $in | merge ({id: (random uuid), created_at: (date now), updated_at: (date now) }) | into sqlite $vicinaedb -t shortcut
        }
      NU
      fi
    '')
  ];

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

    [colors.main_window]
    border = "#${nixosConfig.defaults.colorScheme.palette.base02}"
    footer = { background = "#${nixosConfig.defaults.colorScheme.palette.base01}" }

    [colors.settings_window]
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

    [colors.shortcut]
    border = "#${nixosConfig.defaults.colorScheme.palette.base02}"

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
    foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}"
    hover = { background = "#${nixosConfig.defaults.colorScheme.palette.base03}" }
    focus = { outline = "#${nixosConfig.defaults.colorScheme.palette.base0D}" }

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

    [colors.loading]
    bar = "#${nixosConfig.defaults.colorScheme.palette.base05}"
    spinner = "#${nixosConfig.defaults.colorScheme.palette.base05}"
  '';
}
