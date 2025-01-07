{
  pkgs,
  config,
  defaults,
  lib,
  inputs,
  ...
}: let
  hexToDec = hex: inputs.nix-colors.lib.conversions.hexToDec hex;
  hexToHSL = hex: let
    rgb = {
      r = (hexToDec (builtins.substring 0 2 hex)) / 255.0;
      g = (hexToDec (builtins.substring 2 2 hex)) / 255.0;
      b = (hexToDec (builtins.substring 4 2 hex)) / 255.0;
    };
    maxValue = lib.trivial.max rgb.r (lib.trivial.max rgb.g rgb.b);
    minValue = lib.trivial.min rgb.r (lib.trivial.min rgb.g rgb.b);
    l = (maxValue + minValue) / 2;
    delta = maxValue - minValue;
    s =
      if delta == 0.0
      then 0
      else if l <= 0.5
      then delta / (maxValue + minValue)
      else delta / (2 - maxValue - minValue);
    h_raw =
      if delta == 0.0
      then 0
      else if maxValue == rgb.r
      then 60 * ((rgb.g - rgb.b) / delta)
      else if maxValue == rgb.g
      then 60 * (2 + (rgb.b - rgb.r) / delta)
      else 60 * (4 + (rgb.r - rgb.g) / delta);
    h =
      if h_raw < 0
      then h_raw + 360
      else h_raw;
  in "${toString (builtins.floor h)} ${toString (builtins.floor (s * 100))} ${toString (builtins.floor (l * 100))}";

  # https://github.com/glanceapp/glance/blob/main/docs/extensions.md

  other = {
    name = "Other";
    columns = [
      {
        size = "small";
        widgets = [
          {
            type = "repository";
            repository = "NixOS/nixpkgs";
          }

          {
            title = "Releases";
            type = "rss";
            cache = "1h";
            feeds = [
              {
                title = "Ollama";
                url = "https://github.com/ollama/ollama/releases.atom";
              }
              {
                title = "Immich";
                url = "https://github.com/immich-app/immich/releases.atom";
              }

              {
                title = "ES-DE";
                url = "https://gitlab.com/es-de/emulationstation-de/-/releases.atom";
              }
              {
                title = "SilverBullet";
                url = "https://github.com/silverbulletmd/silverbullet/releases.atom";
              }
              {
                title = "Memos";
                url = "https://github.com/usememos/memos/releases.atom";
              }
              {
                title = "Glance";
                url = "https://github.com/glanceapp/glance/releases.atom";
              }
            ];
          }
        ];
      }
      {
        size = "full";
        cache = "1h";
        widgets = [
          {
            type = "rss";
            title = "comics";
            style = "horizontal-cards";
            feeds = [
              {
                title = "XKCD";
                url = "https://xkcd.com/rss.xml";
              }
              {
                title = "Cyanide & Happiness";
                url = "https://www.smbc-comics.com/comic/rss";
              }
            ];
          }

          {
            type = "hacker-news";
          }

          {
            type = "lobsters";
          }
        ];
      }
    ];
  };

  homePage = {
    name = "Home";
    columns = [
      {
        size = "small";
        widgets = [
          {
            type = "weather";
            location = defaults.location;
          }
          {type = "calendar";}

          {
            type = "markets";
            cache = "1h";
            markets = [
              {
                symbol = "AAPL";
                name = "Apple";
                symbol-link = "https://www.google.com/search?tbm=nws&q=apple";
              }
              {
                symbol = "NVDA";
                name = "NVDA";
              }
              {
                symbol = "BTC-USD";
                name = "Bitcoin";
                chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:BTCUSD";
              }
            ];
          }

          {
            type = "monitor";
            cache = "15m";

            sites = [
              {
                title = "Home Assistant";
                url = "https://home.knoopx.net";
              }
            ];
          }
        ];
      }

      {
        size = "full";

        widgets = [
          {
            # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#videos
            type = "videos";
            cache = "30m";
            channels = [
              "UCu-NRUdNtfcjdGA5Abt3JUw"
              "UCdC0An4ZPNr_YiFiYoVbwaw"
              "UCsBjURrPoezykLs9EqgamOA"
              "UCq2rNse2XX4Rjzmldv9GqrQ"
              "UC1VLQPn9cYSqx8plbk9RxxQ"
              "UCj1VqrHhDte54oLgPG4xpuQ"
              "UCgfe2ooZD3VJPB6aJAnuQng"
              "UCEIwxahdLz7bap-VDs9h35A"
              "UC67gfx2Fg7K2NSHqoENVgwA"
              "UC1D3yD4wlPMico0dss264XA"
            ];
          }

          {
            type = "rss";
            cache = "5m";
            feeds = [
              {url = "https://towardsdatascience.com/feed";}
              {url = "https://hnrss.org/frontpage";}
              {url = "https://hnrss.org/show";}
              {url = "https://huggingface.co/blog/feed.xml";}
            ];
          }

          {
            type = "group";
            widgets = [
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "NixOS";
                cache = "30m";
              }

              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "LocalLLaMA";
                cache = "30m";
              }

              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "ElectricSkateboarding";
                cache = "30m";
              }

              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "gnome";
                cache = "30m";
              }

              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "selfhosted";
                cache = "30m";
              }
            ];
          }
        ];
      }

      {
        size = "small";
        widgets = [
          {
            type = "extension";
            allow-potentially-dangerous-html = true;
            url = "http://localhost:${toString config.glance-extensions.port}/github-trending";
          }

          {
            type = "extension";
            allow-potentially-dangerous-html = true;
            url = "http://localhost:${toString config.glance-extensions.port}/xkcd";
          }
        ];
      }
    ];
  };
in {
  imports = [
    ./extensions.nix
  ];

  services.glance = {
    enable = true;

    package = pkgs.glance.overrideAttrs (before: {
      preConfigure = ''
          ${lib.getExe pkgs.ast-grep} run -U -l js internal/assets/static/js/main.js \
            -p 'function setupCollapsibleLists() { $$$ }' \
            --rewrite 'function setupCollapsibleLists() {
          const collapsibleLists = document.querySelectorAll(".list.collapsible-container");
          for (let i = 0; i < collapsibleLists.length; i++) {
            const list = collapsibleLists[i];

            if (list.dataset.collapseAfter === undefined) {
              continue;
            }

            const maxHeight = 400;
            list.style.maxHeight = `''${maxHeight}px`;
            list.style.overflowY = "auto";
            list.style.position = "relative";
          }
        }'
      '';
    });

    settings = {
      server = {
        port = 9000;
        host = "localhost";
      };
      branding = {
        hide-footer = true;
        logo-text = "K";
      };
      theme = with defaults.colorScheme.palette; {
        # contrast-multiplier = 1.2;
        background-color = hexToHSL base00;
        primary-color = hexToHSL base07;
        positive-color = hexToHSL base0B;
        negative-color = hexToHSL base08;
      };
      pages = [
        homePage
        other
      ];
    };
  };
}
