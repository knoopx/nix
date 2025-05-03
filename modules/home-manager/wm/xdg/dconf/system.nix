{defaults, ...}: {
  dconf.settings = {
    "system/locale" = {
      region = defaults.region;
    };
  };
}
