{
  pkgs,
  lib,
  ...
}: let
  browser = "firefox.desktop";
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
            url = "https://raw.githubusercontent.com/doppelhelix/dalci-skel/1c24ae65a90dc1e20e2508785e2f32bd1931e334/etc/skel/.local/share/icons/hicolor/scalable/apps/homeassistant.svg";
            sha256 = "sha256-OogiPi0O4w1kr/LZ0O1Gg9Q9Wn1VD34c42MvBpHf3RU=";
          })
          .outPath;
      };

      android-otg = {
        name = "Android OTG";
        exec = ''${lib.getExe pkgs.scrcpy} --otg'';
        icon =
          (pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/LingmoOS/LingmoOS/2f593c74987037c7d98b9c680f43ebb4a1231a20/shell/bc/Icons/Crule/devices/scalable/tablet.svg";
            sha256 = "sha256-sG2skP8tbH5HjXIPOkrC+5NelUUKKho2Ei+rK+vEC6E=";
          })
          .outPath;
      };

      gmail = {
        name = "Gmail";
        exec = ''xdg-open "https://mail.google.com/"'';
        icon =
          (pkgs.fetchurl {
            url = "https://www.svgrepo.com/download/452213/gmail.svg";
            sha256 = "sha256-mDJqB47Gw3vWmxxeJCPY84FIpBx4IlbSgYr+B3t7P9U=";
          })
          .outPath;
      };

      # telegram = {
      #   name = "Telegram";
      #   exec = ''xdg-open "https://web.telegram.org/k/"'';
      #   icon =
      #     (pkgs.fetchurl {
      #       url = "https://raw.githubusercontent.com/Ashwatthaamaa/Neuwaita/refs/heads/main/scalable/apps/org.telegram.desktop.svg";
      #       sha256 = "sha256-+F8rb2dCYCZW/s8kzH24bGiNgNFWYDgSBD2osdxvmsY=";
      #     })
      #     .outPath;
      # };

      # whatsapp = {
      #   name = "WhatsApp";
      #   exec = ''xdg-open "https://web.whatsapp.com/"'';
      #   icon =
      #     (pkgs.fetchurl {
      #       url = "https://static.whatsapp.net/rsrc.php/yp/r/iBj9rlryvZv.svg";
      #       sha256 = "sha256-QmNVdkQ5QwVITocMZ8Hlf26P559OdrCJO6ezPoMKUeI=";
      #     })
      #     .outPath;
      # };

      # spotify = {
      #   name = "Spotify";
      #   exec = ''xdg-open "https://open.spotify.com/"'';
      #   icon =
      #     (pkgs.fetchurl {
      #       url = "https://open.spotifycdn.com/cdn/images/icons/Spotify_1024.31b25879.png";
      #       sha256 = "sha256-MbJYed49mTS56YqTzohLBdnfngOoAASRJ98rZIhvAFU=";
      #     })
      #     .outPath;
      # };
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
