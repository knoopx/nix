{defaults, ...}: {
  # easy-effects
  # https://extensions.gnome.org/extension/4907/easyeffects-preset-selector/

  xdg.configFile."easyeffects/irs/" = {
    source = ../assets/irs;
    recursive = true;
  };

  xdg.configFile."easyeffects/output/default.json".text = ''
    {
      "output": {
        "convolver#0": {
            "kernel-path": "${defaults.easyeffects.irs}",
        },
        "plugins_order": [
            "convolver#0"
        ]
      }
    }
  '';

  services = {
    easyeffects = {
      enable = true;
      preset = "default";
    };
  };
}
