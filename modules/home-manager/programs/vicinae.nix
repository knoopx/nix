{
  config,
  nixosConfig,
  ...
}: {
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    useLayerShell = false;

    settings = {
      closeOnFocusLoss = true;
      faviconService = "google";
      font = {
        size = 10;
      };
      keybinding = "default";
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
      popToRootOnClose = true;
      rootSearch = {
        searchFiles = false;
      };
      theme = {
        iconTheme = config.gtk.iconTheme.name;
        name = "custom";
      };
      window = {
        csd = true;
        opacity = 1;
        rounding = 8;
      };
    };
  };

  home.file.".local/share/flatpak/exports/share/vicinae/themes/custom.toml".text = ''
    [meta]
    version = 1
    name = "Custom Theme"
    description = "Custom Theme"
    variant = "dark"
    inherits = "vicinae-dark"

    [colors.core]
    accent = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
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
    selection = { background = "#${nixosConfig.defaults.colorScheme.palette.base0D}",
    foreground = "#${nixosConfig.defaults.colorScheme.palette.base00}" }

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

    [colors.loading]
    bar = "#${nixosConfig.defaults.colorScheme.palette.base05}"
    spinner = "#${nixosConfig.defaults.colorScheme.palette.base05}"
  '';
}
