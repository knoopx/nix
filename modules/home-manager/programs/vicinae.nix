{
  lib,
  config,
  nixosConfig,
  pkgs,
  ...
}: let
  j-vicinae-extensions = pkgs.fetchFromGitHub {
    owner = "dagimg-dot";
    repo = "j-vicinae-extensions";
    rev = "main";
    sha256 = "sha256-yirdUhHEJ9tNQoPubMJHUBwOpXFOevjqyaJlcW3+d5I=";
  };
  wifi = pkgs.runCommand "vicinae-extensions" {} ''
    cp -r ${j-vicinae-extensions}/extensions/wifi-commander $out/
  '';
in {
  services.vicinae.enable = true;

  home.file.".local/share/vicinae/extensions/wifi" = lib.mkIf nixosConfig.defaults.wifi {source = wifi;};

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

  home.file.".config/vicinae/vicinae.json".text = builtins.toJSON {
    faviconService = "google";
    font = {
      size = 10;
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
}
