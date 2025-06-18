{
  pkgs,
  config,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = config.defaults.colorScheme;
    fonts = config.defaults.fonts;
    cursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Snow";
      size = 24;
    };
  };
}
