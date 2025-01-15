{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    fuzzy
    webkit-shell
    shttp
    shamls
    wl-clipboard
  ];

  xdg.configFile."shamls/config.yaml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/home-manager/shamls/config.yaml";
  };
}
