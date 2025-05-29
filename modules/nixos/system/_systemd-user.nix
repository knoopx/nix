{
  pkgs,
  lib,
  ...
}: {
  # Enable systemd user service support
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin"
  '';

  # Ensure user services can access system buses properly
  services.dbus.packages = with pkgs; [
    gcr
    gnome-keyring
  ];

  # Fix for common systemd user service issues in GNOME/GDM sessions
  environment.pathsToLink = [
    "/share/dbus-1/services"
    "/share/dbus-1/system-services"
  ];

  # Ensure proper session management
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Additional environment variables for session consistency
  environment.sessionVariables = {
    # Ensure proper XDG directories
    XDG_DATA_DIRS = lib.mkAfter [
      "/usr/share"
      "/usr/local/share"
    ];
  };
}
