{nixosConfig, ...}: {
  dconf.settings = {
    "system/locale" = {
      region = nixosConfig.defaults.region;
    };
  };
}
