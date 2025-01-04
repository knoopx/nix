{
  defaults,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.firefox-homepage;
  colors = builtins.toJSON (lib.attrsets.mapAttrsToList (k: v: {
      key = k;
      value = "#${v}";
    })
    cfg.base16);
in {
  imports = [
    ./feeds.nix
    ./weather.nix
    ./xkcd.nix
  ];

  options.firefox-homepage = {
    pollRate = lib.mkOption {default = 60;};
    base16 = lib.mkOption {default = defaults.colorScheme.palette;};
    path = lib.mkOption {default = "${config.home.homeDirectory}/.local/share/firefox-homepage/index.html";};

    json = lib.mkOption {
      default = pkgs.writeShellApplication {
        name = "firefox-homepage-json";
        runtimeInputs = with pkgs; [mustache-go gcalcli csvkit];
        text = ''
          cat <<JSON
          {
              "inbox": [],
              "picture": "$(${lib.getExe config.xkcd.url})",
              "weather": $(${lib.getExe config.weather.json}),
              "events": $(gcalcli agenda --tsv | csvjson),
              "feeds": $(${lib.getExe config.feeds.json}),
              "colors": ${colors}
          }
          JSON
        '';
      };
    };

    html = lib.mkOption {
      default = pkgs.writeShellApplication {
        name = "firefox-homepage-html";
        runtimeInputs = with pkgs; [mustache-go];
        text = ''
          ${lib.getExe cfg.json} | mustache ${./template.html}
        '';
      };
    };
  };

  config = {
    home.packages = [cfg.json cfg.html];
    systemd.user.services."firefox-homepage" = {
      Install.WantedBy = ["default.target"];
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.html} > ${cfg.path}";
      };
    };

    systemd.user.timers."firefox-homepage" = {
      Timer = {
        OnUnitActiveSec = cfg.pollRate;
        Unit = "firefox-homepage.service";
      };
      Install = {WantedBy = ["timers.target" "firefox-homepage.target"];};
    };
  };
}
