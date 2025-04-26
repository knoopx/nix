{
  pkgs,
  lib,
  defaults,
  ...
}: {
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
