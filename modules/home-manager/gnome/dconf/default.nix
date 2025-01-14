{
  defaults,
  pkgs,
  lib,
  ...
}: let
  mkTuple = lib.hm.gvariant.mkTuple;
in {
  imports = [
    ./astra-monitor.nix
  ];

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
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "gmail.desktop"
        "org.gnome.Calendar.desktop"
        "slack.desktop"
        "telegram.desktop"
        "whatsapp.desktop"
        "spotify.desktop"
        "home-assistant.desktop"
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
      cycle-group-backward = ["<Shift><Super>Escape"];
      toggle-fullscreen = ["<Super>f"];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/system-monitor" = {
      binding = "<Control><Alt>Delete";
      command = "gnome-system-monitor";
      name = "System Monitor";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/navi" = {
      binding = "<Super>r";
      command = lib.getExe pkgs.launcher;
      name = "Launcher";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      logout = [];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/system-monitor/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/navi/"
      ];
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
  };
}
