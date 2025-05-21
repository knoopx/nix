{
  pkgs,
  lib,
  ...
}: {
  xdg = {
    desktopEntries = {
      home-assistant = {
        name = "Home Assistant";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://home.knoopx.net/lovelace"'';
        icon =
          (pkgs.fetchurl {
            url = "https://www.svgrepo.com/show/331429/home-assistant.svg";
            sha256 = "sha256-HhM9DTOBOHDkf1Undzb1d9mVoHpv9VRsmlAtci0cglg=";
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
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://mail.google.com/"'';
        icon =
          (pkgs.fetchurl {
            url = "https://www.svgrepo.com/download/452213/gmail.svg";
            sha256 = "sha256-mDJqB47Gw3vWmxxeJCPY84FIpBx4IlbSgYr+B3t7P9U=";
          })
          .outPath;
      };

      telegram = {
        name = "Telegram";
        exec = ''${lib.getExe pkgs.webkit-shell} --ur "https://web.telegram.org/k/"'';
        icon = "telegram";
      };

      youtube = {
        name = "Youtube";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://www.youtube.com/"'';
        icon =
          (pkgs.fetchurl {
            url = "https://www.svgrepo.com/show/134513/youtube.svg";
            sha256 = "sha256-JCxh77q9DO9vnznBWDILyLO7nGRk0UFqcZ+9l4V7Nuw=";
          })
          .outPath;
      };

      reddit = {
        name = "Reddit";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://www.reddit.com/"'';
        icon =
          (pkgs.fetchurl {
            url = "https://www.svgrepo.com/show/271111/reddit.svg";
            sha256 = "sha256-zuA7+/hLSGsDjpgWEsWrBv+ZNOM4sFkE1fwfVNodRbo=";
          })
          .outPath;
      };

      whatsapp = {
        name = "WhatsApp";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://web.whatsapp.com/"'';
        icon = "whatsapp";
      };

      webull = {
        name = "Webull";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://app.webull.com/stocks"'';
        icon =
          (pkgs.fetchurl {
            url = "https://app.webull.com/static/logo.png";
            # https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/98c67950-4c89-46ec-b5cb-b81b54d05f4c/deky42j-0ced14a8-66a4-4d30-b4ce-3c2eab2cf8b4.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzk4YzY3OTUwLTRjODktNDZlYy1iNWNiLWI4MWI1NGQwNWY0Y1wvZGVreTQyai0wY2VkMTRhOC02NmE0LTRkMzAtYjRjZS0zYzJlYWIyY2Y4YjQucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.WbM1NgY6Y9ZO1w0Ux7xAzxzeLdeMTF8iTp2cc0jUZN0
            sha256 = "sha256-WAW/LjVN6vdTfhAlSmkAUXaOrjfqTdCfvKMTCBQHzkE=";
          })
          .outPath;
      };

      # plex = {
      #   name = "Plex Web";
      #   exec = ''${lib.getExe pkgs.webkit-shell} --url "https://app.plex.tv/desktop/"'';
      #   icon = "plexamp";
      # };

      spotify = {
        name = "Spotify";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://open.spotify.com/"'';
        icon = "spotify";
      };

      stylix-palette = {
        name = "Stylix Color Palette";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "file:///etc/stylix/palette.html" --app-id "floating.stylix" --title "Stylix Color Palette" --width 820 --height 470'';
        icon = "x-office-drawing";
      };

      devdocs = {
        name = "DevDocs";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://devdocs.io/"'';
        icon = "x-office-document";
      };

      memos = {
        name = "Memos";
        exec = ''${lib.getExe pkgs.webkit-shell} --url "https://memos.knoopx.net/"'';
        icon = "x-office-document";
      };

      # https://chatgpt.com/
      # https://claudeai.com/
      # https://hugging.chat/
      # https://deepseek.chat/
      # https://gemini.google.com/

      mailto-gmail = {
        name = "Send Email";
        exec = ''${lib.getExe pkgs.raise-or-open-url} "https://mail.google.com/mail/?view=cm&fs=1&to=%u"'';
        mimeType = ["x-scheme-handler/mailto"];
        noDisplay = true;
      };

      ags-restart = {
        name = "Restart AGS";
        exec = lib.getExe pkgs.ags-restart;
        icon = "system-reboot-symbolic";
      };

      # wiki = {
      #   name = "Wiki";
      #   exec = ''${lib.getExe pkgs.webkit-shell} --url "https://wiki.knoopx.net/"'';
      #   icon = "x-office-document";
      # };
    };
  };
}
