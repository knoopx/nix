{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret
  ];

  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;

      config = {
        common = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.Settings" = ["darkman"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.Print" = ["gtk"];
        };
        niri = {
          default = ["wlr" "gtk"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.Settings" = ["darkman"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.Print" = ["gtk"];
        };
      };

      extraPortals = with pkgs; [
        # xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };
}
