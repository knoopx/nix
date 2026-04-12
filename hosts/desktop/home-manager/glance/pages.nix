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
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "RCPlanes";
                cache = "15m";
              }
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "fpv";
                cache = "15m";
              }
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "3Dprinting";
                cache = "15m";
              }
              {
                type = "reddit";
                show-thumbnails = true;
                subreddit = "retrogaming";
                cache = "15m";
              }
            ];
          }
          {
            # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#videos
            type = "videos";
            cache = "15m";
            channels = [
              "UC9TM3Lrth8MQjHrttZJZiEw" # Adam Liaw
              "UCCWeRTgd79JL0ilH0ZywSJA" # AlphaPhoenix
              "UC8zTlrhQ0w1-TZjc2-jdcag" # Andre Antunes
              "UCV0t1y4h_6-2SqEpXBXgwFQ" # AngeTheGreat
              "UCDF3Sd2LNAsa-nKD17Jq3mw" # Bambu Lab
              "UC4NNPgQ9sOkBjw6GlkgCylg" # Ben Vallack
              "UC2Tc0TsvFxC83zF1w5x1PWQ" # Breaks'n'Makes
              "UCRs9vVRoVo4BTBceFRaJnpA" # Brian Brocken
              "UC0A0TIq-WDyKZcGcOt5WpPA" # Brothers Make
              "UC45_6KVAAZG_iOgzksGswMw" # Chris Rosser
              "UCUQo7nzH1sXVpzL92VesANw" # DIY Perks
              "UCNvZxz-G-MDx6hdrT0AcmfA" # DeltaGeek
              "UCCeQLxZHazu4RFqlMmLAw-A" # Donn DIY
              "UCYmna5rFHIesFteksAvFOfg" # Dr. Plants
              "UCSGjvsXMtI70uSvabadwRJg" # Duke Doks
              "UCI2HDanVxEp54l5AQqZor3g" # E3D
              "UCPDis9pjXuqyI7RYLJ-TTSA" # FailArmy
              "UCVveEFTOd6khhSXXnRhxJmg" # Fireball Tool
              "UCWKqh_3cb6cDiz2ICWc-5Sw" # Gear Show
              "UC6mIxFTvXkWQVEHPsEdflzQ" # GreatScott!
              "UC-nPM1_kSZf91ZGkcgy_95Q" # How to ADHD
              "UC2avWDLN1EI3r1RZ_dlSxCw" # Integza
              "UCSksodwjNeOQ3Oywr1G4Nag" # JBV Creative
              "UCHk0IYEDJxQGQ-nbd3yP_KA" # Joel Creates
              "UCJK1WpPzUjz2uIRahllinvw" # Joerg Beigang
              "UC7O8KgJdsE_e9op3vG-p2dg" # Johnny FPV
              "UCX-fEgMLE56OYqEdOpyob7w" # Keith57000
              "UC5rT7F0PGNuD54rJ9kzgWzw" # Kris Harbour Natural Building
              "UCEZME1N4Be_m_vp_pc3zlAA" # KyleRoyerKnives
              "UCJ__W0hroWZTdBA9n96Z8Sg" # MORE Maker's Muse
              "UCRVQnEnQzkhXZ4YiOvKk_TQ" # MW Restoration
              "UCWYV5hJfUrnU9Ishf5vr2KA" # Make It RC
              "UCYfrql-Noh09uq7SURsevTA" # Makerfire
              "UC1O0jDlG51N3jGf6_9t-9mw" # Marco Reps
              "UCRP4g0sUktEbodGx6EUr7mQ" # Matteo Villani
              "UCAVqrVBd18fBnyiyt_wPkoQ" # Mediocre Maker
              "UCBGpbEe0G9EchyGYCRRd4hg" # Nick Burns
              "UCQ3OvT0ZSWxoVDjZkVNmnlw" # Oscar Liang
              "UC2seKgMkTx-ZR1vTT6vUvDw" # Paul's Projects
              "UCUcWguV9it93wMVzkOBPrAQ" # Penguin DIY
              "UC7yF9tV4xWEMZkel7q8La_w" # PeterSripol
              "UC08sUqoDgLKhR4sbNHv3wKA" # Pilotgeek
              "UCPCw5ycqW0fme1BdvNqOxbw" # ProjectAir
              "UCLHAxAdvAKJY0niRJZRYMvg" # Prusa 3D by Josef Prusa
              "UCKd49wwdEdIoM-7Fumhwmog" # Quint BUILDs
              "UCZ22g8sMSoQIF8CnFcNQVXA" # RC Rock Crawler
              "UCX-Fe4LiUYaC6ZzlHvSCfow" # RC Scientific
              "UC873OURVczg_utAk8dXx_Uw" # RCLifeOn
              "UCQVGC2PuLRlS_uKmcNUPReg" # Rat Rig
              "UC4a9LfdavRlVMaSSWFdIciA" # RobWords
              "UCUmG1cB1y35-IpvYZj4t49Q" # SR13_fpv
              "UCMV6M_1IE8y8wr6kEF2Dsuw" # Sciencish
              "UCaFeo-xnmdThDRihD1v39Vg" # Scott Tomlinson
              "UCE-bw6PRKuDlH6fP1mP4nOw" # SeanHodgins
              "UCDJo4LLCjlbupu1DMgvNlDw" # Sent and Bent
              "UC3KEoMzNz8eYnwBC34RaKCQ" # Simone Giertz
              "UC0ng5CCqYTvN0WTwwXYU4Qw" # Smoking Room
              "UCEIwxahdLz7bap-VDs9h35A" # Steve Mould
              "UCNolGmzBR60IZfS9z7LlNEw" # Teenenggr
              "UCFRE4F1oMhKXb4RylmF3Bxw" # Texas BUSHMAN
              "UC5UAwBUum7CPN5buc-_N1Fw" # The Linux Experiment
              "UCZdGJgHbmqQcVZaJCkqDRwg" # The Q
              "UCMZkAT1Vf7CPSNcTzZkK_qQ" # Think Flight
              "UCQSpnDG3YsFNf5-qHocF-WQ" # ThioJoe
              "UC5NO8MgTQKHAWXp6z8Xl7yQ" # This Old Tony
              "UCEaxX1yQlFPmAKbE6AFpBWQ" # Thánh Chế - Mr Hồ
              "UCZYvU-ZWbgl1rJv0trRk_fA" # Tim Station
              "UC67gfx2Fg7K2NSHqoENVgwA" # Tom Stanton
              "UC4Q7GgIQ4kFXnZ3XIBFgUig" # Traxxas
              "UCI2MZOaHJFMAmW5ni7vuAQg" # UAV Tech
              "UCUW49KGPezggFi0PGyDvcvg" # Zack Freedman
              "UCZWadyLVO4ZnMgLrRVtS6VA" # baby WOGUE
              "UCMrMVIBtqFW6O0-MWq26gqw" # my mechanics
              "UCNC9gjgYrzLfyMQmp31DnjA" # myfordboy
              "UC7c1iZQpR8_mct1tCKcjWcw" # quadmovr
              "UC1D3yD4wlPMico0dss264XA" # NileBlue
              "UC1VLQPn9cYSqx8plbk9RxxQ" # The Action Lab
              "UCdC0An4ZPNr_YiFiYoVbwaw" # Daily Dose Of Internet
              "UCgfe2ooZD3VJPB6aJAnuQng" # bycloud
              "UCj1VqrHhDte54oLgPG4xpuQ" # Stuff Made Here
              "UCq2rNse2XX4Rjzmldv9GqrQ" # rctestflight
              "UCsBjURrPoezykLs9EqgamOA" # Fireship
              "UCu-NRUdNtfcjdGA5Abt3JUw" # Mr. Sujano
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
                title = "Vicinae Extensions";
                url = "https://github.com/knoopx/vicinae-extensions/releases.atom";
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
                url = "https://github.com/ollama/ollama/releases.atom";
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
              {
                title = "Pi Mono";
                url = "https://github.com/badlogic/pi-mono/releases.atom";
              }
              {
                title = "llama.cpp";
                url = "https://github.com/ggml-org/llama.cpp/releases.atom";
              }
              {
                title = "Cromite";
                url = "https://github.com/uazo/cromite/releases.atom";
              }
              {
                title = "CodeMapper";
                url = "https://github.com/p1rallels/codemapper/releases.atom";
              }
              {
                title = "JJ Hunk";
                url = "https://github.com/laulauland/jj-hunk/releases.atom";
              }
              {
                title = "Sem";
                url = "https://github.com/Ataraxy-Labs/sem/releases.atom";
              }
              {
                title = "Inspect";
                url = "https://github.com/Ataraxy-Labs/inspect/releases.atom";
              }
              {
                title = "Weave";
                url = "https://github.com/Ataraxy-Labs/weave/releases.atom";
              }
              {
                title = "GOG CLI";
                url = "https://github.com/steipete/gogcli/releases.atom";
              }
              {
                title = "WA CLI";
                url = "https://github.com/steipete/wacli/releases.atom";
              }
              {
                title = "MDTT";
                url = "https://github.com/szktkfm/mdtt/releases.atom";
              }
              {
                title = "ROMie";
                url = "https://github.com/JZimz/romie/releases.atom";
              }
              {
                title = "NFOView";
                url = "https://github.com/otsaloma/nfoview/releases.atom";
              }
              {
                title = "Astal Shell";
                url = "https://github.com/knoopx/astal-shell/releases.atom";
              }
              {
                title = "Camper";
                url = "https://github.com/knoopx/camper/releases.atom";
              }
              {
                title = "Waveshare Genui";
                url = "https://github.com/knoopx/waveshare-genui/releases.atom";
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
