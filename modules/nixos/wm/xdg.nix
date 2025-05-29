{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret
    gvfs
  ];

  # Ensure proper session management
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config = {
        common = {
          default = [
            "gtk"
          ];
        };
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "gnome"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [
            "gnome"
          ];
          "org.freedesktop.impl.portal.Screenshot" = [
            "gnome"
          ];
        };
      };
    };
  };
}
