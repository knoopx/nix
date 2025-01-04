{
  defaults,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feeds;
  pairs = lib.strings.concatStringsSep "\n" (lib.lists.flatten (lib.attrsets.mapAttrsToList (k: v: (lib.lists.forEach v (x: "${k}\t${x}"))) cfg.feeds));

  fetch-feed = pkgs.writeShellApplication {
    name = "fetch-feed";
    runtimeInputs = with pkgs; [curl duckdb dasel];
    text = let
      feed = ''
        INSTALL inet; LOAD inet;
        SELECT
          published AS date,
          html_unescape(title) AS title,
          author.name AS author,
          struct_extract(link, '-href') AS link,
          html_unescape(struct_extract(content, '#text')) AS description
        FROM read_json('/dev/stdin')
      '';

      rss = ''
        INSTALL inet; LOAD inet;
        CREATE TABLE items (
            pubDate VARCHAR,
            guid VARCHAR,
            title VARCHAR,
            author VARCHAR,
            creator VARCHAR,
            link VARCHAR,
            description VARCHAR,
            comments VARCHAR,
        );
        INSERT INTO items BY NAME FROM read_csv('/dev/stdin');

        SELECT
          strptime(pubDate, '%a, %d %b %Y %H:%M:%S %z') AS date,
          html_unescape(title) AS title,
          if(author, author, creator) as author,
          link,
          html_unescape(description) as description
        FROM items;
      '';
    in ''
      output=$(curl -s "$1")
      if [[ "$output" == *"<rss"* ]]; then
        echo "$output" | dasel -r xml -w csv "rss.channel.item" | duckdb -csv -c "${rss}"
      else
        echo "$output" | dasel -r xml -w json "feed.entry" | duckdb -csv -c "${feed}"
      fi
    '';
  };
in {
  options.feeds = {
    feeds = lib.mkOption {default = defaults.feeds;};
    poll = lib.mkOption {default = false;};
    pollRate = lib.mkOption {default = 60;};
    cachePath = lib.mkOption {default = "${config.home.homeDirectory}/.cache/feeds";};

    json = lib.mkOption {
      default = pkgs.writeShellApplication {
        name = "feeds-json";
        runtimeInputs = with pkgs; [duckdb];
        text = let
          sql = ''
            SELECT DISTINCT ON (link)
            COLUMNS(['date', 'title', 'author', 'link', 'description'])
            FROM read_csv_auto('$path/*', union_by_name=true)
            ORDER BY date
            DESC
          '';
        in ''
          echo "["
          for path in ${cfg.cachePath}/*; do
            if [ -d "$path" ]; then
              title=$(basename "$path")
              echo "{ \"title\": \"$title\", \"items\": $(duckdb -json -c "${sql}") },"
            fi;
          done;
          echo "]"
        '';
      };
    };

    fetch = lib.mkOption {
      default = pkgs.writeShellApplication {
        name = "fetch-feeds";
        text = ''
          while IFS=$'\t' read -r folder url; do
              dir="${cfg.cachePath}/$folder"
              file="$dir/$(echo "$url" | sha256sum | awk '{print $1}')"
              echo "Fetching $url"
              mkdir -p "$dir"
              ${lib.getExe fetch-feed} "$url" > "$file"
          done <<PAIRS
          ${pairs}
          PAIRS
        '';
      };
    };
  };

  config = {
    home.packages = [fetch-feed cfg.fetch cfg.json];

    systemd.user.services."feeds" = {
      Install.WantedBy = ["default.target"];
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.fetch}";
      };
    };

    systemd.user.timers."feeds" = lib.mkIf cfg.poll {
      Timer = {
        OnUnitActiveSec = "60";
        Unit = "feeds.service";
      };
      Install = {WantedBy = ["timers.target" "feeds.target"];};
    };
  };
}
