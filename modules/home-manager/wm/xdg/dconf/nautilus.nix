{
  nixosConfig,
  lib,
  ...
}: {
  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-view = "icon-view";
      click-policy = "double";
      fts-enabled = false;
      show-delete-permanently = true;
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "extra-large";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = lib.hm.gvariant.mkTuple nixosConfig.defaults.display.windowSize;
      maximized = false;
    };
  };
}
