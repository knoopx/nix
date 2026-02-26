{nixosConfig, ...}: let
  # inherit (flake.lib) mimetypes;
  browser = nixosConfig.defaults.apps.browser.desktopEntry;
  file-manager = nixosConfig.defaults.apps.fileManager.desktopEntry;
  image-viewer = nixosConfig.defaults.apps.imageViewer.desktopEntry;
  # image-viewer = "org.gnome.Loupe.desktop";
  video-player = "mpv.desktop";
  # video-player = "org.gnome.Showtime";
  music-player = "org.gnome.Decibels";
  text-editor = "code.desktop";
  # music-player = "io.bassi.Amberol.desktop";
in {
  xdg = {
    mimeApps = {
      enable = true;
      # https://mimetype.io/
      # xdg-mime query filetype input.png
      # xdg-mime query default "image/*"

      defaultApplications =
        # (mimetypes.genAssoc mimetypes.archive "org.gnome.FileRoller.desktop")
        # // (mimetypes.genAssoc mimetypes.image "org.gnome.Loupe.desktop")
        {
          "application/pdf" = "org.gnome.Evince.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-gzip" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/zip" = "org.gnome.FileRoller.desktop";
          "audio/mpeg" = music-player;
          "audio/flac" = music-player;
          "audio/vnd.wave" = music-player;
          "image/gif" = image-viewer;
          "image/jpeg" = image-viewer;
          "image/png" = image-viewer;
          "image/svg" = image-viewer;
          "image/tiff" = image-viewer;
          "image/webp" = image-viewer;
          "inode/directory" = file-manager;
          "text/html" = browser;
          "text/xml" = text-editor;
          "application/json" = text-editor;
          "text/markdown" = text-editor;
          "text/plain" = text-editor;
          "video/mpeg" = video-player;
          "video/webm" = video-player;
          "video/x-matroska" = video-player;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/unknown" = browser;
          "x-scheme-handler/mailto" = "mailto-gmail.desktop";
          "x-scheme-handler/magnet" = "userapp-transmission-gtk-FROFT2.desktop";
        };
    };
  };
}
