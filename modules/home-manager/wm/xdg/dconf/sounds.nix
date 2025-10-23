{pkgs, ...}: {
  # Sound configuration for Niri + XDG portals + GNOME components
  # These dconf settings provide compatibility for GTK/Qt applications
  dconf.settings = {
    "org/gnome/desktop/sound" = {
      event-sounds = true;
      input-feedback-sounds = true;
      theme-name = "freedesktop";
    };

    "org/gnome/desktop/sound/input-feedback" = {
      bell = true;
    };
  };
}
