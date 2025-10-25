{
  pkgs,
  lib,
  config,
  ...
}: let
  soundDir = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo";
  pwPlay = "${pkgs.pipewire}/bin/pw-play";
in
  lib.mkIf config.defaults.sound {
    # Enable XDG Sound Theme specification support
    xdg.sounds.enable = true;

    # Install sound theme package
    environment.systemPackages = with pkgs; [
      sound-theme-freedesktop
    ];

    # Udev rules for device plug/eject sounds
    services.udev.extraRules = ''
      # Play sound when mass storage devices are plugged in
      ACTION=="add", SUBSYSTEM=="block", KERNEL=="sd*", RUN+="${pwPlay} ${soundDir}/device-added.oga"
      ACTION=="add", SUBSYSTEM=="block", KERNEL=="nvme*n*", RUN+="${pwPlay} ${soundDir}/device-added.oga"

      # Play sound when mass storage devices are ejected
      ACTION=="remove", SUBSYSTEM=="block", KERNEL=="sd*", RUN+="${pwPlay} ${soundDir}/device-removed.oga"
      ACTION=="remove", SUBSYSTEM=="block", KERNEL=="nvme*n*", RUN+="${pwPlay} ${soundDir}/device-removed.oga"

      # Play sound when network interfaces are added/removed
      ACTION=="add", SUBSYSTEM=="net", RUN+="${pwPlay} ${soundDir}/network-connectivity-established.oga"
      ACTION=="remove", SUBSYSTEM=="net", RUN+="${pwPlay} ${soundDir}/network-connectivity-lost.oga"

      # Play sound when power is plugged in/out
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pwPlay} ${soundDir}/power-plug.oga"
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pwPlay} ${soundDir}/power-unplug.oga"
    '';

    # Systemd user services for login/logout sounds
    systemd.user.services.login-sound = {
      description = "Play login sound";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target" "pipewire.service"];
      partOf = ["graphical-session.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pwPlay} ${soundDir}/service-login.oga";
        RemainAfterExit = "no";
      };
    };

    systemd.user.services.logout-sound = {
      description = "Play logout sound";
      wantedBy = ["graphical-session-pre.target"];
      before = ["graphical-session-pre.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pwPlay} ${soundDir}/service-logout.oga";
        RemainAfterExit = "no";
      };
    };
  }
