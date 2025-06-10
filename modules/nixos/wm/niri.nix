{pkgs, ...}: {
  environment.systemPackages = [pkgs.xdg-utils pkgs.niri];
  xdg = {
    autostart.enable = true;
    menus.enable = true;
    mime.enable = true;
    icons.enable = true;
  };

  services.displayManager.sessionPackages = [pkgs.niri];
  hardware.graphics.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  systemd.user.services.niri-polkit = {
    description = "PolicyKit Authentication Agent for Niri";
    wantedBy = ["niri.service"];
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  security.pam.services.swaylock = {};
  programs.dconf.enable = true;
  fonts.enableDefaultPackages = true;
}
