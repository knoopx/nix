{
  pkgs,
  defaults,
  config,
  ...
}: {
  imports = [
    ./wallpaper.nix
    ./gnome-shell.nix
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";

    # https://github.com/dharmx/walls
    image = config.wallpaper.pkg.outPath;

    base16Scheme = defaults.colorScheme;

    fonts = defaults.fonts;

    cursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Snow";
      # name = "Quintom_Ink";

      # package = pkgs.simp1e-cursors;
      # name = "Simp1e-Adw";
      # name = "Simp1e-Catppuccin-Mocha";
      size = 24;
    };

    # targets.gnome.enable = false;
  };
}
