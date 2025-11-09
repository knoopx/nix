{
  config,
  nixosConfig,
  ...
}: let
  homePage = {
    name = "Home";
    columns = [
      {
        size = "small";
        widgets = [
          {
            type = "weather";
            location = nixosConfig.defaults.location;
          }
          {type = "calendar";}
          {
            type = "custom-api";
            title = "Vilassar de Mar Departures";
            url = "https://serveisgrs.rodalies.gencat.cat/api/departures?stationId=79410&minute=60&fullResponse=true&lang=en";
            cache = "5m";
            template = ''
              <ul style="text-wrap:nowrap" class="list list-gap-14">
                {{ range $index, $train := .JSON.Array "trains" }}{{ if lt $index 5 }}
                <li style="overflow:hidden;text-wrap:nowrap">
                  {{ if gt ($train.Int "delay") 0 }}<span title="+{{ $train.Int "delay" }}min">⚠️</span>{{else}}🕒{{ end }}
                  {{ $train.String "departureDateHourSelectedStation" | parseTime "2006-01-02T15:04:05" | formatTime "15:04" }}
                  ⇢ {{ $train.String "destinationStation.name" }}
                </li>
                {{ end }}{{ end }}
              </ul>
            '';
          }
          {
            type = "markets";
            cache = "1h";
            markets = [
              {
                symbol = "NVDA";
                name = "Nvidia";
              }

              {
                symbol = "NET";
                name = "Cloudflare";
              }

              {
                symbol = "MSFT";
                name = "Microsoft Corp";
              }

              {
                symbol = "AMZN";
                name = "Amazon";
              }

              {
                symbol = "XPEV";
                name = "Xpeng";
              }

              {
                symbol = "BABA";
                name = "Alibaba";
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

          {
            type = "custom-api";
            title = "XKCD";
            url = "https://xkcd.com/info.0.json";
            template = ''
              <img src="{{ .JSON.String "img" }}" alt="{{ .JSON.String "alt" }}" title="{{ .JSON.String "title" }}" loading="lazy" />
            '';
          }
        ];
      }

      {
        size = "full";

        widgets = [
          {
            type = "rss";
            cache = "5m";
            feeds = [
              {url = "https://community.silverbullet.md/latest.rss";}
              {url = "https://discourse.nixos.org/latest.rss";}
              {url = "https://towardsdatascience.com/feed";}
              {url = "https://huggingface.co/blog/feed.xml";}
            ];
          }

          {
            type = "group";
            widgets = [
              {
                type = "hacker-news";
              }

              {
                type = "lobsters";
              }
              {
                type = "rss";
                title = "Stonks";
                feeds = [
                  {
                    title = "unusual_whales";
                    url = "https://nitter.privacydev.net/unusual_whales/rss";
                  }
                  {
                    title = "NVDA";
                    url = "https://news.google.com/rss/search?q=nvda+when:1d&hl=en-US&gl=US&ceid=US:en";
                  }
                  {
                    title = "NET";
                    url = "https://news.google.com/rss/search?q=cloudflare+when:1d&hl=en-US&gl=US&ceid=US:en";
                  }
                  {
                    title = "MSFT";
                    url = "https://news.google.com/rss/search?q=msft+when:1d&hl=en-US&gl=US&ceid=US:en";
                  }
                  {
                    title = "AMZN";
                    url = "https://news.google.com/rss/search?q=amzn+when:1d&hl=en-US&gl=US&ceid=US:en";
                  }
                ];
              }
            ];
          }
          {
            type = "group";
            widgets = [
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "NixOS";
                cache = "15m";
              }

              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "niri";
                cache = "15m";
              }
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "gnome";
                cache = "15m";
              }
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "selfhosted";
                cache = "15m";
              }
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "LocalLLaMA";
                cache = "15m";
              }
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "ElectricSkateboarding";
                cache = "15m";
              }
            ];
          }
          {
            # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#videos
            type = "videos";
            cache = "15m";
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
            title = "comics";
            style = "horizontal-cards";
            feeds = [
              {
                title = "XKCD";
                url = "https://xkcd.com/rss.xml";
              }
              {
                title = "Cyanide & Happiness";
                url = "https://explosm-1311.appspot.com/";
              }
            ];
          }
        ];
      }

      {
        size = "small";
        widgets = [
          {
            type = "custom-api";
            title = "GitHub Trending";
            url = "https://githubtrending.lessx.xyz/trending?since=daily";
            cache = "1h";
            template = ''
              <ul class="list list-gap-14 collapsible-container" data-collapse-after="5">
                {{ range .JSON.Array "" }}
                <li>
                  <a class="size-h3 color-primary-if-not-visited" href="{{ .String "repository" }}">{{ .String "name" }}</a>
                  <ul class="list-horizontal-text">
                    <li>{{ .String "description" }}</li>
                    <li>{{ .String "language" }} • {{ .String "stars" }} stars • {{ .String "increased" }}</li>
                  </ul>
                </li>
                {{ end }}
              </ul>
            '';
          }

          {
            title = "Releases";
            type = "rss";
            cache = "1h";
            feeds = [
              {
                title = "FreshTomato";
                url = "https://github.com/FreshTomato-Project/freshtomato-arm/releases.atom";
              }
              {
                title = "Vicinae";
                url = "https://github.com/vicinaehq/vicinae/releases.atom";
              }
              {
                title = "Visual Studio Code";
                url = "https://github.com/microsoft/vscode/releases.atom";
              }
              {
                title = "Niri";
                url = "https://github.com/YaLTeR/niri/releases.atom";
              }
              {
                title = "Yazi";
                url = "https://github.com/sxyazi/yazi/releases.atom";
              }
              {
                title = "Ollama";
                url = "https://github.com/YaLTeR/niri/releases.atom";
              }
              {
                title = "Home Assistant";
                url = "https://github.com/home-assistant/core/releases.atom";
              }
              {
                title = "Zigbee2MQTT";
                url = "https://github.com/Koenkk/zigbee2mqtt/releases.atom";
              }
              {
                title = "SilverBullet";
                url = "https://github.com/silverbulletmd/silverbullet/releases.atom";
              }
              {
                title = "Glance";
                url = "https://github.com/glanceapp/glance/releases.atom";
              }
            ];
          }
          {
            type = "repository";
            repository = "NixOS/nixpkgs";
          }
          {
            type = "repository";
            repository = "YaLTeR/niri";
          }
        ];
      }
    ];
  };
in {
  # https://github.com/glanceapp/glance/blob/main/docs/extensions.md
  config = {
    services.glance.settings.pages = [
      homePage
    ];
  };
}
