{
  pkgs,
  config,
  lib,
  defaults,
  ...
}: let
  cfg = config.weather;
in {
  options.weather = {
    lat = lib.mkOption {default = builtins.elemAt defaults.location 0;};
    lon = lib.mkOption {default = builtins.elemAt defaults.location 1;};
    units = lib.mkOption {default = "metric";};
    apiKey = lib.mkOption {default = "431be9d4368fb6f3c34ed852832d22db";};

    json = lib.mkOption {
      default = pkgs.writeShellApplication {
        name = "fetch-weather";
        runtimeInputs = with pkgs; [curl];
        text = ''
          curl "http://api.openweathermap.org/data/3.0/onecall?lat=${toString cfg.lat}&lon=${toString cfg.lon}&units=${cfg.units}&lang=en&exclude=minutely&appid=${cfg.apiKey}"
        '';
      };
    };
  };

  config = {
    home.packages = [
      cfg.json
    ];
  };
}
