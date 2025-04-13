{config, ...}: {
  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 5d --keep 3";
      flake = "${config.home.homeDirectory}/.dotfiles";
    };
  };
}
