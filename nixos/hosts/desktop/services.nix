{defaults, ...}: {
  services = {
    btrfs.autoScrub.enable = true;

    # plex = {
    #   enable = true;
    #   dataDir = "/var/lib/plex";
    #   # openFirewall = true;
    #   user = "plex";
    #   group = "plex";
    # };

    # silverbullet = {
    #   enable = true;
    #   spaceDir = "/home/knoopx/Documents/Second Brain";
    #   user = "knoopx";
    #   group = "knoopx";
    # };

    ollama = {
      enable = true;
      acceleration = "cuda";
      # home = "/home/${defaults.username}/.ollama";
    };
  };
}
