{pkgs, ...}: {
  # Enable XDG Sound Theme specification support
  xdg.sounds.enable = true;

  # Install sound theme package
  environment.systemPackages = with pkgs; [
    sound-theme-freedesktop
  ];

  # Udev rules for device plug/eject sounds
  services.udev.extraRules = ''
    # Play sound when mass storage devices are plugged in
    ACTION=="add", SUBSYSTEM=="block", KERNEL=="sd*", RUN+="${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/device-added.oga"
    ACTION=="add", SUBSYSTEM=="block", KERNEL=="nvme*n*", RUN+="${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/device-added.oga"

    # Play sound when mass storage devices are ejected
    ACTION=="remove", SUBSYSTEM=="block", KERNEL=="sd*", RUN+="${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/device-removed.oga"
    ACTION=="remove", SUBSYSTEM=="block", KERNEL=="nvme*n*", RUN+="${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/device-removed.oga"
  '';

  # Systemd user services for login/logout sounds
  systemd.user.services.login-sound = {
    description = "Play login sound";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target" "pipewire.service"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/service-login.oga";
      RemainAfterExit = "no";
    };
  };

  systemd.user.services.logout-sound = {
    description = "Play logout sound";
    wantedBy = ["graphical-session-pre.target"];
    before = ["graphical-session-pre.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/service-logout.oga";
      RemainAfterExit = "no";
    };
  };
}