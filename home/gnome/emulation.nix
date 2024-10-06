{pkgs, ...}: {
  home.packages = with pkgs; [
    # higan
    mame-tools
    rpcs3
    retroarchFull
    lime3ds
    pcsx2
    xemu
    cemu

    (callPackage ../../pkgs/es-de-appimage.nix {})
    (callPackage ../../pkgs/ryujinx {})
    # (callPackage ../../pkgs/shadps4.nix {})
    (callPackage ../../pkgs/sudachi.nix {})
    # melonDS
    # dosbox
    # bottles
    # protonup
    # wineWowPackages.waylandFull
    # lutris
    # https://redream.io/download/redream.x86_64-linux-v1.5.0-1131-gafdfc1a.tar.gz
  ];
}
