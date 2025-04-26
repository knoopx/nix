{
  pkgs,
  lib,
  defaults,
  ...
}: {
  # [R-]  #43  xdg-desktop-portal-gtk                                           1.15.3
  # [R-]  #44  xdg-user-dirs-gtk                                                0.14

  environment.systemPackages = with pkgs; [
    libsecret
  ];

  services.gnome.gnome-keyring.enable = true;
  # security.pam.services.lightdm.enableGnomeKeyring = true;
  # security.pam.services.login.enableGnomeKeyring = true;

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;
      config.common.default = "*";
      extraPortals = lib.mkIf defaults.wm.gnome [
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
