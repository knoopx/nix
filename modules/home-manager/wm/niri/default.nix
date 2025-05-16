{
  defaults,
  pkgs,
  lib,
  ...
}: let
  # wallpaper = pkgs.theming.mkSVGPatternWallpaper {
  #   style = pkgs.pattern-monster.zebra;
  #   scale = 4;
  #   colors = with defaults.colorScheme.palette; [
  #     #   base01
  #     base00
  #     base02
  #     base03
  #     base04
  #   ];
  # };
  # https://github.com/NotAShelf/wallpkgs
  wallpaper-src = fetchTarball {
    url = "https://github.com/42willow/wallpapers/releases/download/wallpapers/wallpapers-mocha.zip";
    sha256 = "sha256:10s315bd998r73p6i1bhlihc6hkq81jabkhjf24viz61xbs2898r";
  };
  # wallpaper = "${wallpaper-src}/mocha/images/photography/leaves_with_droplets.jpg";
  # wallpaper = "${wallpaper-src}/mocha/images/photography/trees_mountain_fog_1.jpg";
  # wallpaper = "${wallpaper-src}/mocha/images/photography/mountains.jpg";
  # wallpaper = "${wallpaper-src}/mocha/images/art/kurzgesagt/asteroid_miner_2.png";
  # wallpaper = "${wallpaper-src}/mocha/images/art/kurzgesagt/asteroids.png";
  wallpaper = "${wallpaper-src}/mocha/pixel/art/animated_street_night.gif";
in {
  home.packages = with pkgs; [
    kooha
    libnotify
    polkit_gnome
    raise-or-open-url
  ];

  # https://github.com/emersion/mako/blob/master/doc/mako.5.scd
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      markup = true;
      icons = true;
      layer = "top";
      anchor = "top-right";
      border-size = 0;
      border-radius = 10;
      padding = 10;
      width = 330;
      height = 200;
      default-timeout = 5000;
      max-icon-size = 32;
      text-color = lib.mkForce "#${defaults.colorScheme.palette.base00}";
      background-color = lib.mkForce "#${defaults.colorScheme.palette.base0D}";
    };
  };

  systemd.user.services = {
    wallpaper = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Unit = {
        BindTo = ["niri.service"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        # ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper}";
        # https://github.com/LGFae/swww
        ExecStart = ''${lib.getExe pkgs.mpvpaper} -o "no-audio --loop --video-zoom=0.17" '*' ${wallpaper}'';

        Restart = "on-failure";
      };
    };
  };
}
