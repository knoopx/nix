{pkgs, ...}: {
  home.packages = with pkgs; [
    wine
    umu

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

    es-de-bin
    ryujinx
    uncrashed
    factorio-space-age

    # driver-san-francisco
    # brothers-a-tale-of-two-sons-remake
    # supermeatboy
    # celeste
    # worldofgoo
    # liftoff

    rpcs3

    # lime3ds
    # pcsx2
    # xemu
    # cemu
    # melonDS
    # dosbox
    # bottles
    # protonup
    # wineWowPackages.waylandFull
    # lutris
    # mindustry-wayland
  ];
}
