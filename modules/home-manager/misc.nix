{nixosConfig, ...}: {
  home.file.".face" = {source = nixosConfig.defaults.avatarImage;};
}
