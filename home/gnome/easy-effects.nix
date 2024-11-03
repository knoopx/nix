{
  defaults,
  config,
  pkgs,
  ...
}: let
  # irs = pkgs.fetchzip {
  #   url = "https://www.dropbox.com/scl/fo/26ehvd5a3q96gci65zv5z/AGBwTqyIH4c7_24xXuO97XI/zhuhangsirs%20-%20Waves%20MaxxAudio%20Pro%2BAW%20%28%28128k%29%29%20-%2019042015.zip?rlkey=s2d723reaq1sl4thdgrl49u9u&dl=1";
  #   extension = "zip";
  #   stripRoot = false;
  #   sha256 = "sha256-xonYAuGKYQEGfxL8ZkPjwY1sSTx1hYDOEQx1WwzmqUU=";
  # };
  irs =
    (fetchTarball {
      url = "https://github.com/programminghoch10/ViPER4AndroidRepackaged/archive/refs/heads/main.zip";
      sha256 = "sha256:01nr2zr4i2bh12ww82fklx0cdrrk0cply9k096fgbyk51lxlql78";
    })
    + "/ViperIRS";
in {
  # TODO: https://extensions.gnome.org/extension/4907/easyeffects-preset-selector/

  xdg.configFile."easyeffects/irs/" = {
    source = irs;
    recursive = true;
  };

  dconf.settings = {
    "com/github/wwmm/easyeffects/streamoutputs/convolver" = {
      kernel-path = "${config.home.homeDirectory}/.config/easyeffects/irs/${defaults.easyeffects.irs}.irs";
    };
  };

  services = {
    easyeffects = {
      enable = true;
      # package = pkgs.easyeffects.overrideAttrs (prev: {
      #   preFixup = "";
      #   buildInputs = pkgs.lib.filter (item:
      #     !(pkgs.lib.elem item [
      #       pkgs.deepfilternet
      #       pkgs.rubberband
      #     ]))
      #   pkgs.easyeffects.buildInputs;
      # });
    };
  };
}
