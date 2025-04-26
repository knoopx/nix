{
  pkgs,
  nixosConfig,
  config,
  defaults,
  lib,
  ...
}: let
  mkTuple = lib.hm.gvariant.mkTuple;

  gnomeExtensions = with pkgs.gnomeExtensions; [
    hot-edge
    user-themes
    caffeine
    panel-corners
    astra-monitor
    steal-my-focus-window
    paperwm
    smart-auto-move
  ];
in
  lib.mkIf defaults.wm.gnome {
    home.packages = gnomeExtensions;

    dconf.settings = {
      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "suspend";
        sleep-inactive-ac-timeout = 60 * 30;
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;
        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
          "gmail.desktop"
          "org.gnome.Calendar.desktop"
          "android-otg.desktop"
          # "slack.desktop"
          "telegram.desktop"
          "whatsapp.desktop"
          "spotify.desktop"
          "webull.desktop"
          "home-assistant.desktop"
        ];
        enabled-extensions = map (extension: extension.extensionUuid) gnomeExtensions;
      };

      "org/gnome/mutter" = {
        attach-modal-dialogs = false;
        edge-tiling = true;
        center-new-windows = true;
        workspaces-only-on-primary = true;
      };

      "org/gnome/desktop/wm/preferences" = {
        action-middle-click-titlebar = "minimize";
        auto-raise = true;
        focus-mode = "click";
        focus-new-windows = "smart";
        raise-on-click = true;
      };
      # https://github.com/GNOME/gsettings-desktop-schemas/blob/master/schemas/org.gnome.desktop.wm.keybindings.gschema.xml.in
      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [];
        close = ["<Super>q" "<Super>w"];
        switch-applications = ["<Super>Tab" "<Alt>Tab"];
        switch-applications-backward = ["<Shift><Super>Tab" "<Shift><Alt>Tab"];
        cycle-group = ["<Super>Escape"];
        cycle-group-backward = ["<Shift><Super>Escape"];
        toggle-fullscreen = ["<Super>f"];
      };

      "org/gnome/shell/extensions/user-theme".name = "Custom";

      "org/gnome/desktop/background" = {
        picture-options = "zoom";
        picture-uri = "file://${config.stylix.image}";
        picture-uri-dark = "file://${config.stylix.image}";
      };

      "org/gnome/desktop/interface" = let
        inherit (config.stylix.fonts) sansSerif serif monospace;
        fontSize = toString config.stylix.fonts.sizes.applications;
        documentFontSize = toString (config.stylix.fonts.sizes.applications - 1);
      in {
        cursor-theme = config.stylix.cursor.name;
        color-scheme = "prefer-dark";
        font-name = "${sansSerif.name} ${fontSize}";
        document-font-name = "${serif.name}  ${documentFontSize}";
        monospace-font-name = "${monospace.name} ${fontSize}";
        clock-show-weekday = true;
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

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/system-monitor" = {
        binding = "<Control><Alt>Delete";
        command = "gnome-system-monitor";
        name = "System Monitor";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        logout = [];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/system-monitor/"
        ];
      };

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };

      "org/gnome/desktop/calendar" = {
        show-weekdate = true;
      };

      "org/gnome/desktop/datetime" = {
        automatic-timezone = true;
      };

      "org/gnome/desktop/input-sources" = {
        per-window = false;
        show-all-sources = true;
        sources = [(mkTuple ["xkb" defaults.keyMap])];
      };
    };
  }
