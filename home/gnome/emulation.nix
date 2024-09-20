{pkgs, ...}: {
  home.packages = with pkgs; [
    mame-tools
    rpcs3
    retroarchFull
    pcsx2
    xemu
    cemu
    higan
    (callPackage ../../pkgs/es-de-appimage.nix {})
    (callPackage ../../pkgs/ryujinx.nix {})
    # (callPackage ../../pkgs/sudachi.nix {})
    # melonDS
    # dosbox
    # bottles
    # protonup
    # wineWowPackages.waylandFull
    # lutris
    # https://redream.io/download/redream.x86_64-linux-v1.5.0-1131-gafdfc1a.tar.gz
  ];
}
