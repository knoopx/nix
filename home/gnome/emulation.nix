{pkgs, ...}: {
  home.packages = with pkgs; [
    mame-tools
    retroarchFull
    (callPackage ../../pkgs/es-de-appimage.nix {})
    # (callPackage ../../pkgs/ryujinx {})

    # higan
    # rpcs3
    # lime3ds
    # pcsx2
    # xemu
    # cemu
    # (callPackage ../../pkgs/shadps4.nix {})
    # (callPackage ../../pkgs/sudachi {})
    # melonDS
    # dosbox
    # bottles
    # protonup
    # wineWowPackages.waylandFull
    # lutris
    # https://redream.io/download/redream.x86_64-linux-v1.5.0-1131-gafdfc1a.tar.gz
  ];
}
