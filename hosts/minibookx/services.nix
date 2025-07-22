{
  pkgs,
  lib,
  ...
}: {
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "powersave";
      turbo = "never";
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["0001:0001"];
        settings = {
          main = {
            leftmeta = "leftalt";
            leftalt = "overload(meta, M-.)";
          };
        };
      };
    };
  };
}
