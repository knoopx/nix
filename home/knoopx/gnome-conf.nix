{
  defaults,
  inputs,
  ...
}: let
  astra = {
    monitors = ["network" "processor" "gpu" "memory" "storage"];
    sections = [
      "header-graph"
      "header-io-bars"
      "header-bars"
      "header-icon"
    ];
    colors = {
      color1 = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base0E})";
      color2 = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base02})";
      alert = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base08})";
    };
  };
in {
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      favorite-apps = ["nautilus.desktop" "google-chrome.desktop" "kitty.desktop"];
      enabled-extensions = map (extension: extension.extensionUuid) defaults.gnome.extensions;
    };

    "org/gnome/desktop/wm/preferences" = {
      auto-raise = true;
      action-middle-click-titlebar = "minimize";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      cycle-group = ["<Shift><Super>escape"];
      cycle-group-backward = ["<Super>escape"];
    };
    "org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3";
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      # font-antialiasing = "grayscale";
      # font-hinting = "slight";
    };

    # https://github.com/AstraExt/astra-monitor/blob/main/schemas/org.gnome.shell.extensions.astra-monitor.gschema.xml
    "org/gnome/shell/extensions/astra-monitor" = {
      monitors-order = ''["network", "processor", "gpu", "memory", "storage"]'';
      gpu-header-icon = false;
      memory-header-bars = false;
      memory-header-graph = true;
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

      gpu-header-icon-alert-color = astra.colors.alert;
      gpu-header-bars-color1 = astra.colors.color1;
      gpu-header-bars-color2 = astra.colors.color2;
      gpu-header-graph-color1 = astra.colors.color1;
      gpu-header-graph-color2 = astra.colors.color2;
      gpu-header-io-bars-color1 = astra.colors.color1;
      gpu-header-io-bars-color2 = astra.colors.color2;
      gpu-header-io-graph-color1 = astra.colors.color1;
      gpu-header-io-graph-color2 = astra.colors.color2;

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
