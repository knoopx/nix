{
  pkgs,
  defaults,
  config,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    image = config.wallpaper.pkg.outPath;
    base16Scheme = defaults.colorScheme;
    fonts = defaults.fonts;
    cursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Snow";
      size = 24;
    };
  };
}
