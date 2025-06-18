{
  nixosConfig,
  pkgs,
  lib,
  ...
}: let
  mkTuple = lib.hm.gvariant.mkTuple;
in {
  home.packages = [
    pkgs.adwaita-icon-theme
    (pkgs.theming.mkMoreWaitaIconTheme nixosConfig.defaults.colorScheme.palette)
  ];

  xdg.dataFile."gtksourceview-5/styles/catppuccin-mocha.xml".source = let
    themeContent = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/gedit/refs/heads/main/themes/catppuccin-mocha.xml";
      sha256 = "sha256-+Ew1IR0GjGSJJUOe4DOws+V2AtvojG+zUfXI9ZD7CAE=";
    };
  in
    pkgs.runCommand "catppuccin-mocha.xml" {} ''
      cp ${themeContent} $out
      substituteInPlace $out --replace-fail 'kind="dark">' 'kind="dark" version="1.0">'
    '';

  gtk = {
    iconTheme = {
      name = "Neuwaita";
      package = pkgs.neuwaita-icon-theme;
    };
  };

  dconf.settings = {
    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = nixosConfig.defaults.display.sidebarWidth;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple nixosConfig.defaults.display.windowSize;
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = nixosConfig.defaults.display.sidebarWidth;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple nixosConfig.defaults.display.windowSize;
    };
  };
}
