{
  pkgs,
  defaults,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";

    # open /etc/stylix/palette.html
    base16Scheme = defaults.colorScheme;

    fonts = {
      sizes.applications = 11;

      sansSerif = {
        name = "Inter";
        package = pkgs.inter;
      };

      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts;
      };
    };
    image = ./assets/wallpapers/alexander-popov-ez4pqCpEfuI-unsplash.jpg;
  };
}
