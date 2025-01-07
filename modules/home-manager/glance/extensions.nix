{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.glance-extensions;
  inherit (lib) mapAttrsToList;

  github-trending-template = pkgs.writeTextFile {
    name = "github-trending-template.mustache";
    text = ''
      <ul class="list list-gap-14 collapsible-container" data-collapse-after="5">
        {{#.}}
        <li>
          <a class="size-h3 color-primary-if-not-visited" href="{{{link}}}">{{{title}}}</a>
          <ul class="list-horizontal-text">
            <li>{{description}}</li>
          </ul>
        </li>
        {{/.}}
      </ul>
    '';
  };

  sql = ''INSTALL inet; LOAD inet; SELECT title,link, regexp_extract(html_unescape(description), '<p>(.*?)</p>', 1) as description  FROM read_csv('/dev/stdin')'';

  github-trending = pkgs.writeShellApplication {
    name = "github-trending";
    runtimeInputs = with pkgs; [curl dasel duckdb mustache-go];
    text = ''
      printf "Widget-Title: GitHub Trending\n";
      printf "Widget-Content-Type: html\n";
      printf "\n";

      curl "https://mshibanami.github.io/GitHubTrendingRSS/daily/all.xml" | dasel -r xml -w csv "rss.channel.item" | duckdb -json -c "${sql}" | mustache ${github-trending-template}
    '';
  };

  xkcd = pkgs.writeShellApplication {
    name = "xkcd";
    runtimeInputs = with pkgs; [curl htmlq];
    text = ''
      printf "Widget-Title: XKCD\n";
      printf "Widget-Content-Type: html\n";
      printf "\n";

      url="https:$(curl -s https://xkcd.com/ | htmlq --attribute src "#comic img")"
      echo "<img src='$url' loading='lazy' />"
    '';
  };
in {
  options.glance-extensions = {
    port = lib.mkOption {default = 9001;};
    api = lib.mkOption {
      default = {
        "/xkcd" = lib.getExe xkcd;
        "/github-trending" = lib.getExe github-trending;
      };
    };
  };

  config = {
    home.packages = [github-trending];
    systemd.user.services."glance-extensions" = {
      Service = {
        Restart = "on-failure";
        ExecStart = lib.strings.escapeShellArgs ([
            (lib.getExe pkgs.shell2http)
            "-port"
            (toString cfg.port)
            "-cgi"
          ]
          ++ (lib.lists.flatten (mapAttrsToList (k: v: [k v]) cfg.api)));
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
