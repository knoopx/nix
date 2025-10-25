{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    libnotify
    polkit_gnome
    squeekboard
  ];

  # https://github.com/emersion/mako/blob/master/doc/mako.5.scd
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      markup = true;
      icons = true;
      layer = "overlay";
      anchor = "top-right";
      border-size = 0;
      border-radius = 10;
      padding = 10;
      width = 330;
      height = 200;
      default-timeout = 5000;
      max-icon-size = 32;
      text-color = lib.mkForce "#${nixosConfig.defaults.colorScheme.palette.base00}";
      background-color = lib.mkForce "#${nixosConfig.defaults.colorScheme.palette.base0D}";
      on-notify = "exec ${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message.oga";
    };
  };

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "GNOME Polkit Authentication Agent";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["niri.service"];
      };
    };
  };
}
