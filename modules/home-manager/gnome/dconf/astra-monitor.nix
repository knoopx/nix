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
      color1 = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base07})";
      color2 = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base02})";
      positive = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base0B})";
      negative = "rgb(${inputs.nix-colors.lib-core.conversions.hexToRGBString "," defaults.colorScheme.palette.base08})";
    };
  };
in {
  dconf.settings = {
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

      network-header-icon-alert-color = astra.colors.negative;
      network-header-bars-color1 = astra.colors.color2;
      network-header-bars-color2 = astra.colors.color1;
      network-header-graph-color1 = astra.colors.color2;
      network-header-graph-color2 = astra.colors.color1;
      network-header-io-bars-color1 = astra.colors.color2;
      network-header-io-bars-color2 = astra.colors.color1;
      network-header-io-graph-color1 = astra.colors.color2;
      network-header-io-graph-color2 = astra.colors.color1;
      network-menu-arrow-color1 = astra.colors.positive;
      network-menu-arrow-color2 = astra.colors.negative;

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

      memory-header-icon-alert-color = astra.colors.negative;
      memory-header-bars-color1 = astra.colors.color1;
      memory-header-bars-color2 = astra.colors.color2;
      memory-header-graph-color1 = astra.colors.color1;
      memory-header-graph-color2 = astra.colors.color2;
      memory-header-io-bars-color1 = astra.colors.color1;
      memory-header-io-bars-color2 = astra.colors.color2;
      memory-header-io-graph-color1 = astra.colors.color1;
      memory-header-io-graph-color2 = astra.colors.color2;
      memory-menu-swap-color = astra.colors.color1;

      processor-header-icon-alert-color = astra.colors.negative;
      processor-header-bars-color1 = astra.colors.color1;
      processor-header-bars-color2 = astra.colors.color2;
      processor-header-graph-color1 = astra.colors.color1;
      processor-header-graph-color2 = astra.colors.color2;
      processor-header-io-bars-color1 = astra.colors.color1;
      processor-header-io-bars-color2 = astra.colors.color2;
      processor-header-io-graph-color1 = astra.colors.color1;
      processor-header-io-graph-color2 = astra.colors.color2;

      storage-header-icon-alert-color = astra.colors.negative;
      storage-header-bars-color1 = astra.colors.color1;
      storage-header-bars-color2 = astra.colors.color2;
      storage-header-graph-color1 = astra.colors.color1;
      storage-header-graph-color2 = astra.colors.color2;
      storage-header-io-bars-color1 = astra.colors.color1;
      storage-header-io-bars-color2 = astra.colors.color2;
      storage-header-io-graph-color1 = astra.colors.color1;
      storage-header-io-graph-color2 = astra.colors.color2;
      storage-menu-device-color = astra.colors.color1;
      storage-menu-arrow-color1 = astra.colors.positive;
      storage-menu-arrow-color2 = astra.colors.negative;
    };
  };
}
