{nixosConfig, ...}: let
  browser = nixosConfig.defaults.apps.browser.desktopEntry;
  file-manager = nixosConfig.defaults.apps.fileManager.desktopEntry;
  image-viewer = nixosConfig.defaults.apps.imageViewer.desktopEntry;
  video-player = nixosConfig.defaults.apps.videoPlayer.desktopEntry;
  music-player = nixosConfig.defaults.apps.musicPlayer.desktopEntry;
  pdf-viewer = nixosConfig.defaults.apps.pdfViewer.desktopEntry;
  archive-manager = nixosConfig.defaults.apps.archiveManager.desktopEntry;
  text-editor = nixosConfig.defaults.apps.editor.desktopEntry;
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
          "application/pdf" = pdf-viewer;
          "application/x-bzip2" = archive-manager;
          "application/x-gzip" = archive-manager;
          "application/x-tar" = archive-manager;
          "application/zip" = archive-manager;
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
          "x-scheme-handler/mailto" = browser;
          "x-scheme-handler/magnet" = browser;
        };
    };
  };
}
