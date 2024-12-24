{
  pkgs,
  config,
  ...
}: let
  custom = {
    retroarch = pkgs.retroarch.withCores (
      cores:
        with cores; [
          # beetle-ngp
          # beetle-pce
          # beetle-psx
          # beetle-saturn
          # beetle-supergrafx
          # beetle-vb
          # beetle-wswan
          # bluemsx
          # bsnes
          # bsnes-hd
          # dosbox-pure
          # freeintv
          # fuse
          # handy
          # hatari
          # mame
          # picodrive
          # prosystem
          # stella
          citra
          dolphin
          fbneo
          flycast
          gambatte
          genesis-plus-gx
          melonds
          mesen
          mgba
          mupen64plus
          pcsx2
          ppsspp
          puae
          snes9x
        ]
    );
    dolphin-emu =
      pkgs
      .dolphin-emu
      .overrideAttrs
      {
        version = "2412";
      };

    retool = pkgs.retool.overrideAttrs (origAttrs: {
      postFixup =
        origAttrs.postFixup
        + ''
          ln -s ${config.home.homeDirectory}/.config/retool $out/bin/config
          ln -s ${config.home.homeDirectory}/.local/retool/datafile.dtd $out/bin/datafile.dtd
          ln -s ${config.home.homeDirectory}/.local/retool/clonelists $out/bin/clonelists
          ln -s ${config.home.homeDirectory}/.local/retool/metadata $out/bin/metadata
        '';
    });
  };

  launchers = with pkgs; [
    es-de
    pegasus-frontend
    # lutris
    # steam
    # bottles
  ];

  games = with pkgs; [
    # liftoff
    # supermeatboy
    # uncrashed
    # brothers-a-tale-of-two-sons-remake
    # celeste
    # driver-san-francisco
    # mindustry-wayland
    # worldofgoo
    factorio-space-age
  ];

  emulators = with pkgs; [
    # xemu
    # dosbox
    # melonDS
    # rpcs3
    # pcsx2
    # lime3ds
    ryujinx
    citron-emu
    cemu
    custom.dolphin-emu
    custom.retroarch
  ];

  tools = with pkgs; [
    # wiiudownloader
    # hydra-launcher
    # skyscraper
    # alvr
    # protonup
    # wineWowPackages.waylandFull
    mame-tools
    nsz
    nstool
    umu
    custom.retool
  ];
in {
  home.packages = launchers ++ emulators ++ games ++ tools;

  xdg.configFile."pegasus-frontend/themes/gameOS" = {
    source = fetchTarball {
      url = "https://github.com/PlayingKarrde/gameOS/releases/download/1.10/gameOS.zip";
      sha256 = "sha256:1ph487fnl7ayn5fgzb381fnzw2daj09r7q6hy0papaq579i1knsf";
    };
    recursive = true;
  };
}
