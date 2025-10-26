{
  lib,
  inputs,
  config,
  nixosConfig,
  pkgs,
  ...
}: let
  # https://github.com/schromp/vicinae-extensions/
  j-vicinae-extensions = pkgs.fetchFromGitHub {
    owner = "dagimg-dot";
    repo = "j-vicinae-extensions";
    rev = "main";
    sha256 = "14kpzrnp2rd2r7mghyjff6jhw72h8z16rvl3896xn9y4259dsana";
  };
in {
  services.vicinae = {
    enable = true;
    extensions = [
      # TODO
      # (lib.mkIf nixosConfig.defaults.wifi (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
      #   inherit pkgs;
      #   name = "wifi-commander";
      #   src = "${j-vicinae-extensions}/extensions/wifi-commander";
      # }))
      (lib.mkIf nixosConfig.defaults.bluetooth (inputs.vicinae.mkVicinaeExtension.${pkgs.system} {
        inherit pkgs;
        name = "bluetooth";
        src = pkgs.fetchgit {
          url = "https://codeberg.org/gelei/vicinae-bluetooth.git";
          rev = "16204787e0ac3925e7e466df38f3a959294b440f";
          sha256 = "sha256-xOemsBLnXKfcCVOZew2vm0mlylfFvcX4s/AnpjF3kBo=";
        };
      }))
    ];
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
