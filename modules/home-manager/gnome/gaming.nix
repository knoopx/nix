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
    citron-emu
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
    es-de
    factorio-space-age
    mame-tools
    nstool
    nsz
    hydra-launcher
    # (retool.overrideAttrs (origAttrs: {
    #   preConfigure = ''
    #     substituteInPlace modules/constants.py --replace-fail "'config/" "'~/.config/retool/"
    #     substituteInPlace modules/update_clone_list_metadata.py --replace-fail "config.retool_location" "'~/.config/retool/'"
    #   '';
    # }))
    retroarchFull
    ryujinx
    umu
    # wiiudownloader
    # hydra-launcher
    (dolphin-emu
      .overrideAttrs
      {
        version = "2412";
        # src = fetchFromGitHub {
        #   owner = "dolphin-emu";
        #   repo = "dolphin";
        #   rev = "refs/tags/${version}";
        #   hash = "sha256-x4ZtV/5bwUjcmdYneG7n7uFVyPmYj0sD8TXEqsqbUFU=";
        #   fetchSubmodules = true;
        # };
      })
  ];
}
