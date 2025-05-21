{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret
    xdg-desktop-portal
    xdg-user-dirs-gtk
  ];

  # security.pam.services.lightdm.enableGnomeKeyring = true;
  # security.pam.services.login.enableGnomeKeyring = true;

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      # https://github.com/waycrate/xdg-desktop-portal-luminous
      wlr.enable = true;
      config = {
        common = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.Settings" = ["darkman"];
        };
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      # ++ (if defaults.wm.gnome [
      #     xdg-desktop-portal-gnome)
      # ] : []);
    };
  };
}
