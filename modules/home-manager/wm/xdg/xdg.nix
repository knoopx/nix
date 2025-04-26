{
  defaults,
  pkgs,
  lib,
  ...
}: {
  home.file.".face" = {source = defaults.avatar-image;};
  dconf.settings = {
    "system/locale" = {
      region = defaults.region;
    };
  };

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
        settings = {
          StartupWMClass = ".scrcpy-wrapped";
        };
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

      telegram = {
        name = "Telegram";
        exec = ''xdg-open "https://web.telegram.org/k/"'';
        icon = "telegram";
      };

      whatsapp = {
        name = "WhatsApp";
        exec = ''xdg-open "https://web.whatsapp.com/"'';
        icon = "whatsapp";
      };

      spotify = {
        name = "Spotify";
        exec = ''xdg-open "https://open.spotify.com/"'';
        icon = "spotify";
      };

      webull = {
        name = "Webull";
        exec = ''xdg-open "https://app.webull.com/stocks"'';
        icon =
          (pkgs.fetchurl {
            url = "https://app.webull.com/static/logo.png";
            # https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/98c67950-4c89-46ec-b5cb-b81b54d05f4c/deky42j-0ced14a8-66a4-4d30-b4ce-3c2eab2cf8b4.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzk4YzY3OTUwLTRjODktNDZlYy1iNWNiLWI4MWI1NGQwNWY0Y1wvZGVreTQyai0wY2VkMTRhOC02NmE0LTRkMzAtYjRjZS0zYzJlYWIyY2Y4YjQucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.WbM1NgY6Y9ZO1w0Ux7xAzxzeLdeMTF8iTp2cc0jUZN0
            sha256 = "sha256-WAW/LjVN6vdTfhAlSmkAUXaOrjfqTdCfvKMTCBQHzkE=";
          })
          .outPath;
      };
    };

    mimeApps = {
      enable = true;

      # https://mimetype.io/
      # xdg-mime query filetype input.png
      # xdg-mime query default "image/*"

      defaultApplications = let
        # inherit (flake.lib) mimetypes;
        browser = "firefox.desktop";
        file-manager = "org.gnome.Nautilus.desktop";
        image-viewer = "org.gnome.eog.desktop";
        # image-viewer = "org.gnome.Loupe.desktop";
        video-player = "mpv.desktop";
        # video-player = "org.gnome.Showtime";
        music-player = "org.gnome.Decibels";
        text-editor = "code.desktop";
        # music-player = "io.bassi.Amberol.desktop";
      in
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
          "x-scheme-handler/mailto" = "mailto-gmail.desktop";
          "x-scheme-handler/magnet" = "userapp-transmission-gtk-FROFT2.desktop";
        };
    };
  };
}
