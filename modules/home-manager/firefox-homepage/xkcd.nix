{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.xkcd;
in {
  options.xkcd = {
    url = lib.mkOption {
      default = pkgs.writeShellApplication {
        name = "fetch-xkcd";
        runtimeInputs = with pkgs; [curl htmlq];
        text = ''
          echo "https:$(curl -s https://xkcd.com/ | htmlq --attribute src "#comic img")"
        '';
      };
    };
  };
  config = {
    home.packages = [cfg.url];
  };
}
