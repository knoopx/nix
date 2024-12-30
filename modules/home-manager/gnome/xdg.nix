{pkgs, ...}: let
  browser = "zen.desktop";
  file-manager = "org.gnome.Nautilus.desktop";
  image-viewer = "org.gnome.eog.desktop";
  # image-viewer = "org.gnome.Loupe.desktop";
  video-player = "mpv.desktop";
  # video-player = "org.gnome.Showtime";
  music-player = "org.gnome.Decibels";
  text-editor = "code.desktop";
  # music-player = "io.bassi.Amberol.desktop";
in {
  xdg = {
    desktopEntries = {
      home-assistant = {
        name = "Home Assistant";
        exec = ''xdg-open "https://home.knoopx.net/lovelace"'';
        icon =
          (pkgs.fetchurl {
            url = "https://upload.wikimedia.org/wikipedia/en/thumb/4/49/Home_Assistant_logo_%282023%29.svg/1920px-Home_Assistant_logo_%282023%29.svg.png";
            sha256 = "sha256-AG5JKEjclBkrWs5+Yni3mvO0vJ1S7m+a5rbarCiiO8U=";
          })
          .outPath;
      };
    };

    mimeApps = {
      enable = true;

      # https://mimetype.io/
      # xdg-mime query filetype input.png
      # xdg-mime query default "image/*"

      defaultApplications = {
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
        "x-scheme-handler/mailto" = "mailto-gmail.desktop";
        "x-scheme-handler/magnet" = "userapp-transmission-gtk-FROFT2.desktop";
      };
    };
  };
}
