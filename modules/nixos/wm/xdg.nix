{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret
    xdg-desktop-portal
    xdg-user-dirs-gtk
  ];

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;
    };
  };
}
