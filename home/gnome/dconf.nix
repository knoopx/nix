{
  defaults,
  inputs,
  lib,
  ...
}: let
  mkTuple = lib.hm.gvariant.mkTuple;

  astra = {
    monitors = ["network" "processor" "gpu" "memory" "storage"];
    sections = [
      "header-graph"
      "header-io-bars"
      "header-bars"
      "header-icon"
    ];
    colors = {
      color1 = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base0D})";
      color2 = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base02})";
      alert = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base08})";
    };
  };
in {
  # TODO:
  # system.activationScripts.script.text = ''
  #   cp /home/knoopx/.dotfiles/profile-pic.png /var/lib/AccountsService/icons/knoopx
  # '';
  home.file.".face" = {source = defaults.avatar-image;};

  dconf.settings = {
    "system/locale" = {
      region = defaults.region;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      favorite-apps = [
        "nautilus.desktop"
        "io.github.zen_browser.zen.desktop"
        # "google-chrome.desktop"
        "gmail.desktop"
        "gnome-calendar.desktop"
        "slack.desktop"
        "telegram.desktop"
        "whatsapp.desktop"
        "spotify.desktop"
        "home-assistant.desktop"
        "kitty.desktop"
      ];
      enabled-extensions = map (extension: extension.extensionUuid) defaults.gnome.extensions;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      edge-tiling = true;
      center-new-windows = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-view = "icon-view";
      click-policy = "double";
      fts-enabled = false;
      show-delete-permanently = true;
    };

    "org/gnome/evolution/calendar" = {
      prefer-new-item = "";
      use-24hour-format = true;
      week-start-day-name = "monday";
      work-day-monday = true;
      work-day-tuesday = true;
      work-day-wednesday = true;
      work-day-thursday = true;
      work-day-friday = true;
      work-day-saturday = false;
      work-day-sunday = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      action-middle-click-titlebar = "minimize";
      auto-raise = true;
      focus-mode = "click";
      focus-new-windows = "smart";
      raise-on-click = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
      sleep-inactive-ac-timeout = 60 * 30;
    };

    # https://github.com/GNOME/gsettings-desktop-schemas/blob/master/schemas/org.gnome.desktop.wm.keybindings.gschema.xml.in
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [];
      close = ["<Super>q"];
      minimize = ["<Super>w"];
      cycle-group = ["<Super>Escape" "<Alt>Escape"];
      cycle-group-backward = ["<Shift><Super>escape"];
      toggle-fullscreen = ["<Super>f"];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/system-monitor" = {
      binding = "<Control><Alt>Delete";
      command = "gnome-system-monitor";
      name = "System Monitor";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      logout = [];
      custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/system-monitor/"];
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = lib.mkDefault "adw-gtk3-dark";
      scaling-factor = 1;
      text-scaling-factor = 1.0;
      toolbar-style = "text";
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      color-shading-type = "solid";
      # TODO
      # primary-color = "#000000000000";
      # secondary-color = "#000000000000";
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = defaults.gnome.sidebarWidth;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple defaults.gnome.windowSize;
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = defaults.gnome.sidebarWidth;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple defaults.gnome.windowSize;
    };

    "org/gnome/desktop/input-sources" = {
      per-window = false;
      show-all-sources = true;
      sources = [(mkTuple ["xkb" defaults.keyMap])];
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "extra-large";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple defaults.gnome.windowSize;
      maximized = false;
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = defaults.gnome.sidebarWidth;
      window-width = builtins.elemAt defaults.gnome.windowSize 0;
      window-height = builtins.elemAt defaults.gnome.windowSize 1;
    };

    # https://github.com/AstraExt/astra-monitor/blob/main/schemas/org.gnome.shell.extensions.astra-monitor.gschema.xml
    "org/gnome/shell/extensions/astra-monitor" = {
      monitors-order = ''["network", "processor", "memory", "gpu", "storage"]'';
      gpu-header-icon = false;
      gpu-header-activity-bar = false;
      memory-header-bars = true;
      memory-header-graph = false;
      memory-header-icon = false;
      memory-header-show = true;
      memory-header-value = false;
      network-header-bars = false;
      network-header-graph = true;
      network-header-icon = false;
      network-header-io = true;
      network-header-show = true;
      processor-header-icon = false;
      processor-header-percentage = false;
      storage-header-icon = false;
      storage-header-percentage = false;
      storage-header-show = true;
      storage-header-bars = true;
      storage-header-graph = false;

      network-indicators-order = ''["icon", "IO speed", "IO bar","IO graph"]'';
      gpu-indicators-order = ''["icon","activity bar","activity graph","activity percentage","memory bar","memory graph","memory percentage","memory value"]'';
      memory-indicators-order = ''["icon","bar","graph","percentage","value","free"]'';
      processor-indicators-order = ''["icon","bar","graph","percentage"]'';
      sensors-indicators-order = ''["icon","value"]'';
      storage-indicators-order = ''["icon","bar","percentage","value","free","IO bar","IO graph","IO speed"]'';

      network-header-icon-alert-color = astra.colors.alert;
      network-header-bars-color1 = astra.colors.color2;
      network-header-bars-color2 = astra.colors.color1;
      network-header-graph-color1 = astra.colors.color2;
      network-header-graph-color2 = astra.colors.color1;
      network-header-io-bars-color1 = astra.colors.color2;
      network-header-io-bars-color2 = astra.colors.color1;
      network-header-io-graph-color1 = astra.colors.color2;
      network-header-io-graph-color2 = astra.colors.color1;

      gpu-header-activity-bar-color1 = astra.colors.color1;
      gpu-header-activity-bar-color2 = astra.colors.color2;
      gpu-header-activity-graph-color1 = astra.colors.color1;
      gpu-header-activity-graph-color2 = astra.colors.color2;
      gpu-header-activity-io-bar-color1 = astra.colors.color1;
      gpu-header-activity-io-bar-color2 = astra.colors.color2;
      gpu-header-activity-io-graph-color1 = astra.colors.color1;
      gpu-header-activity-io-graph-color2 = astra.colors.color2;

      gpu-header-memory-bar-color1 = astra.colors.color1;
      gpu-header-memory-bar-color2 = astra.colors.color2;
      gpu-header-memory-graph-color1 = astra.colors.color1;
      gpu-header-memory-graph-color2 = astra.colors.color2;
      gpu-header-memory-io-bar-color1 = astra.colors.color1;
      gpu-header-memory-io-bar-color2 = astra.colors.color2;
      gpu-header-memory-io-graph-color1 = astra.colors.color1;
      gpu-header-memory-io-graph-color2 = astra.colors.color2;

      memory-header-icon-alert-color = astra.colors.alert;
      memory-header-bars-color1 = astra.colors.color1;
      memory-header-bars-color2 = astra.colors.color2;
      memory-header-graph-color1 = astra.colors.color1;
      memory-header-graph-color2 = astra.colors.color2;
      memory-header-io-bars-color1 = astra.colors.color1;
      memory-header-io-bars-color2 = astra.colors.color2;
      memory-header-io-graph-color1 = astra.colors.color1;
      memory-header-io-graph-color2 = astra.colors.color2;

      processor-header-icon-alert-color = astra.colors.alert;
      processor-header-bars-color1 = astra.colors.color1;
      processor-header-bars-color2 = astra.colors.color2;
      processor-header-graph-color1 = astra.colors.color1;
      processor-header-graph-color2 = astra.colors.color2;
      processor-header-io-bars-color1 = astra.colors.color1;
      processor-header-io-bars-color2 = astra.colors.color2;
      processor-header-io-graph-color1 = astra.colors.color1;
      processor-header-io-graph-color2 = astra.colors.color2;

      storage-header-icon-alert-color = astra.colors.alert;
      storage-header-bars-color1 = astra.colors.color1;
      storage-header-bars-color2 = astra.colors.color2;
      storage-header-graph-color1 = astra.colors.color1;
      storage-header-graph-color2 = astra.colors.color2;
      storage-header-io-bars-color1 = astra.colors.color1;
      storage-header-io-bars-color2 = astra.colors.color2;
      storage-header-io-graph-color1 = astra.colors.color1;
      storage-header-io-graph-color2 = astra.colors.color2;
    };
  };
}
