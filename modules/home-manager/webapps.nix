{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.home.webapps;
in {
  # https://github.com/basecamp/omarchy/discussions/2468
  options.home.webapps = {
    enable = lib.mkEnableOption "Web app management tools";

    webapps = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the web app";
          };
          url = lib.mkOption {
            type = lib.types.str;
            description = "URL of the web app";
          };
          icon = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Icon URL or path for the web app";
          };
        };
      });
      default = [
        {
          name = "Home Assistant";
          url = "https://home.knoopx.net/lovelace";
          icon =
            (pkgs.fetchurl {
              url = "https://www.svgrepo.com/show/331429/home-assistant.svg";
              sha256 = "sha256-HhM9DTOBOHDkf1Undzb1d9mVoHpv9VRsmlAtci0cglg=";
            }).outPath;
        }
        {
          name = "Gmail";
          url = "https://mail.google.com/";
          icon =
            (pkgs.fetchurl {
              url = "https://www.svgrepo.com/download/452213/gmail.svg";
              sha256 = "sha256-mDJqB47Gw3vWmxxeJCPY84FIpBx4IlbSgYr+B3t7P9U=";
            }).outPath;
        }
        {
          name = "Telegram";
          url = "https://web.telegram.org/k/";
          icon = "telegram";
        }
        {
          name = "Discord";
          url = "https://discord.com/channels/";
          icon = "discord";
        }
        {
          name = "YouTube";
          url = "https://www.youtube.com/";
          icon =
            (pkgs.fetchurl {
              url = "https://www.svgrepo.com/show/134513/youtube.svg";
              sha256 = "sha256-JCxh77q9DO9vnznBWDILyLO7nGRk0UFqcZ+9l4V7Nuw=";
            }).outPath;
        }
        {
          name = "Reddit";
          url = "https://www.reddit.com/";
          icon =
            (pkgs.fetchurl {
              url = "https://www.svgrepo.com/show/271111/reddit.svg";
              sha256 = "sha256-zuA7+/hLSGsDjpgWEsWrBv+ZNOM4sFkE1fwfVNodRbo=";
            }).outPath;
        }
        {
          name = "WhatsApp";
          url = "https://web.whatsapp.com/";
          icon = "whatsapp";
        }
        {
          name = "Spotify";
          url = "https://open.spotify.com/";
          icon = "spotify";
        }
        {
          name = "Webull";
          url = "https://app.webull.com/stocks";
          icon =
            (pkgs.fetchurl {
              url = "https://app.webull.com/static/logo.png";
              sha256 = "sha256-WAW/LjVN6vdTfhAlSmkAUXaOrjfqTdCfvKMTCBQHzkE=";
            }).outPath;
        }
      ];
      description = "List of web apps to install";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = lib.listToAttrs (map (webapp: {
        name = webapp.name;
        value = {
          name = webapp.name;
          exec = ''
            firefox --no-remote --profile ${config.home.homeDirectory}/.mozilla/firefox/webapp --new-window --class "${webapp.name}" "${webapp.url}"
          '';
          terminal = false;
          type = "Application";
          icon = webapp.icon;
          startupNotify = true;
        };
      })
      cfg.webapps);
  };
}
