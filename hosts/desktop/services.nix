{
  pkgs,
  config,
  ...
}: {
  services = {
    androidPhotoBackup = {
      enable = true;
      backupDir = "/mnt/storage/Photos/input/Android";
      serialShort = "31051JEHN09244";
    };

    udev.packages = with pkgs; [
      via
    ];

    plex = {
      enable = true;
      group = "wheel";
      user = config.defaults.username;
    };

    traefik-proxy = {
      enable = true;
      domain = "knoopx.net";
      hostServices = {
        glance = 9000;
        webdav = 5006;
      };
    };
  };

  systemd.user.services.login-sound = {
    description = "Play login sound";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target" "pipewire.service"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/desktop-login.oga";
      RemainAfterExit = "no";
    };
  };

  systemd.user.services.logout-sound = {
    description = "Play logout sound";
    wantedBy = ["graphical-session-pre.target"];
    before = ["graphical-session-pre.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/desktop-logout.oga";
      RemainAfterExit = "no";
    };
  };
}
