{pkgs, ...}: {
  imports = [
    ./gnome/overlays.nix
    ./gnome/programs.nix
    ./gnome/services.nix
  ];

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;
      config.common.default = "*";
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
