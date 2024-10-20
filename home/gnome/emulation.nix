{pkgs, ...}: {
  home.packages = with pkgs; [
    mame-tools
    # retroarchFull
    (retroarch.override {
      cores = with libretro; [
        mesen
        genesis-plus-gx
        mgba
        gambatte
        puae
        stella
        prosystem
        handy
        hatari
        bluemsx
        dosbox-pure
        flycast
        fbneo
        freeintv
        mame
        # citra
        mupen64plus
        melonds
        beetle-ngp
        beetle-pce
        pcsx2
        ppsspp
        beetle-psx
        snes9x
        beetle-saturn
        picodrive
        beetle-supergrafx
        beetle-vb
        dolphin
        beetle-wswan
        fuse
        bsnes
        bsnes-hd
      ];
    })
    (callPackage ../../pkgs/es-de-appimage.nix {})
    (callPackage ../../pkgs/ryujinx {})
    # (callPackage ../../pkgs/sudachi {})

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
