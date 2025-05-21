{
  ags,
  pkgs,
  ...
}: {
  imports = [ags.homeManagerModules.default];

  programs.ags.enable = true;
  programs.ags.package = ags.packages.x86_64-linux.ags;
  programs.ags.extraPackages = with ags.packages.x86_64-linux; [
    tray
    mpris
    network
    wireplumber
    apps
    cava
    io
    astal3
    astal4
    auth
    greet
    notifd
    powerprofiles
    pkgs.libgtop
  ];
}
