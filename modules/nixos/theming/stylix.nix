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
    fonts = {
      serif = config.defaults.fonts.serif;
      sansSerif = config.defaults.fonts.sansSerif;
      monospace = config.defaults.fonts.monospace;
      emoji = config.defaults.fonts.emoji;
      sizes = {
        applications = config.defaults.fonts.baseSize;
      };
    };
    cursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Snow";
      size = 24;
    };
  };
}
