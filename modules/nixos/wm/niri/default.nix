{
  lib,
  pkgs,
  defaults,
  ...
}:
lib.mkIf defaults.wm.niri {
  environment.systemPackages = with pkgs; [
    niri-unstable
  ];

  services = {
    displayManager = {
      sessionPackages = with pkgs; [
        niri-unstable
      ];
    };
  };

  # services.udev.packages = [pkgs.swayosd];
  # systemd.services.swayosd-libinput-backend = {
  #   description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc.";
  #   documentation = ["https://github.com/ErikReider/SwayOSD"];
  #   wantedBy = ["graphical.target"];
  #   partOf = ["graphical.target"];
  #   after = ["graphical.target"];

  #   serviceConfig = {
  #     Type = "dbus";
  #     BusName = "org.erikreider.swayosd";
  #     ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
  #     Restart = "on-failure";
  #   };
  # };
}
