{pkgs, ...}: let
  browser = "google-chrome.desktop";
  file-manager = "org.gnome.Nautilus.desktop";
  image-viewer = "org.gnome.eog.desktop";
  # image-viewer = "org.gnome.Loupe.desktop";
  video-player = "mpv.desktop";
  music-player = "io.bassi.Amberol.desktop";
  text-editor = "code.desktop";
in {
  xdg = {
    desktopEntries = {
      mailto-gmail = {
        name = "Send Email";
        exec = ''xdg-open "https://mail.google.com/mail/?view=cm&fs=1&to=%u"'';
        mimeType = ["x-scheme-handler/mailto"];
        noDisplay = true;
      };

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

      telegram = {
        name = "Telegram";
        exec = ''xdg-open "https://web.telegram.org/k/"'';
        icon =
          (pkgs.fetchurl {
            url = "https://web.telegram.org/k/assets/img/logo_filled.svg";
            sha256 = "sha256-+F8rb2dCYCZW/s8kzH24bGiNgNFWYDgSBD2osdxvmsY=";
          })
          .outPath;
      };

      whatsapp = {
        name = "WhatsApp";
        exec = ''xdg-open "https://web.whatsapp.com/"'';
        icon =
          (pkgs.fetchurl {
            url = "https://static.whatsapp.net/rsrc.php/yp/r/iBj9rlryvZv.svg";
            sha256 = "sha256-QmNVdkQ5QwVITocMZ8Hlf26P559OdrCJO6ezPoMKUeI=";
          })
          .outPath;
      };

      spotify = {
        name = "Spotify";
        exec = ''xdg-open "https://open.spotify.com/"'';
        icon =
          (pkgs.fetchurl {
            url = "https://open.spotifycdn.com/cdn/images/icons/Spotify_1024.31b25879.png";
            sha256 = "sha256-MbJYed49mTS56YqTzohLBdnfngOoAASRJ98rZIhvAFU=";
          })
          .outPath;
      };

      slack = {
        name = "Slack";
        exec = ''xdg-open "https://app.slack.com/client/T08SBQA2Y/"'';
        icon =
          (pkgs.fetchurl {
            url = "https://slack-status.com/img/icons/icon_slack_hash_colored.svg";
            sha256 = "sha256-unQedNkGItCtknM4vKpgjMkqVYZTTluf4pAT4N+dutA=";
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
        "text/json" = text-editor;
        "text/markdown" = text-editor;
        "text/plain" = text-editor;
        "video/mpeg" = video-player;
        "video/webm" = video-player;
        "video/x-matroska" = video-player;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/mailto" = "mailto-gmail.desktop";
      };
    };
  };
}
