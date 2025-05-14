{
  defaults,
  config,
  pkgs,
  neuwaita,
  lib,
  ...
}: let
  mkTuple = lib.hm.gvariant.mkTuple;
in {
  home.packages = [
    pkgs.adwaita-icon-theme
    (pkgs.theming.mkMoreWaitaTheme defaults.colorScheme.palette)
  ];

  # TODO: --impure
  # xdg.dataFile."gtksourceview-5/styles".source = "${config.home.homeDirectory}/.local/share/gedit/styles";

  gtk = {
    iconTheme = {
      name = "Neuwaita";
      package = pkgs.stdenvNoCC.mkDerivation {
        name = "Neuwaita";
        src = neuwaita;

        installPhase = ''
          mkdir -p $out/share/icons/Neuwaita/{scalable,symbolic}/{apps,devices,legacy,mimetypes,places,status}
          cp -r scalable/* $out/share/icons/Neuwaita/scalable/
          cp -r index.theme $out/share/icons/Neuwaita/index.theme
          substituteInPlace $out/share/icons/Neuwaita/index.theme --replace-fail "Inherits=Adwaita, hicolor, breeze" "Inherits=MoreWaita,Adwaita,hicolor,breeze"
        '';
      };
    };
  };
  dconf.settings = {
    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = defaults.display.sidebarWidth;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple defaults.display.windowSize;
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = defaults.display.sidebarWidth;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple defaults.display.windowSize;
    };
  };
}
