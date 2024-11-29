{pkgs, ...}: let
  cores = with pkgs.libretro; [
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
    citra
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
in {
  home.packages = with pkgs; [
    # alvr
    # bottles
    # brothers-a-tale-of-two-sons-remake
    # celeste
    # cemu
    # citron-emu
    # dosbox
    # driver-san-francisco
    # liftoff
    # lime3ds
    # lutris
    # melonDS
    # mindustry-wayland
    # pcsx2
    # protonup
    # rpcs3
    # skyscraper
    # steam
    # supermeatboy
    # uncrashed
    # wineWowPackages.waylandFull
    # worldofgoo
    # xemu
    cemu
    es-de-bin
    factorio-space-age
    hydra-launcher
    mame-tools
    retool
    retroarchFull
    ryujinx
    umu
    wiiudownloader
  ];
}
