{
  config,
  lib,
  pkgs,
  ...
}: {
  options.services.autoScrcpy = {
    enable = lib.mkEnableOption ''
      Automatically start scrcpy as a systemd user service when an Android device is connected
    '';
  };

  config = lib.mkIf config.services.autoScrcpy.enable {
    users.users.${config.services.autoScrcpy.user} = {
      extraGroups = ["adbusers"];
    };
    environment.systemPackages = with pkgs; [scrcpy android-tools];

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="adbusers"
      ACTION=="add", SUBSYSTEM=="usb", ENV{ID_USB_INTERFACES}=="*:ff4201:*", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="auto-scrcpy.service"
    '';

    systemd.user.services.auto-scrcpy = {
      description = "Auto-start scrcpy for Android device";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.scrcpy}/bin/scrcpy --power-off-on-close --turn-screen-off --stay-awake";
      };
    };
  };
}
