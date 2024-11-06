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

    # mindustry-wayland
    # (callPackage ../../pkgs/gog/world-of-goo-2.nix {})

    (factorio.overrideAttrs
      {
        pname = "factorio";
        version = "2.0.14";
        src = fetchTarball {
          url = "file:///mnt/storage/Games/factorio_linux_2.0.14.tar.xz";
          sha256 = "sha256:0jy2qxayis4gw6fsgr15nbm77fqxrrkvmm0lfw83lhnz9qc05lza";
        };
      })

    # (factorio-space-age.overrideAttrs
    #   (prev: {
    #     version = "2.0.14";
    #     src = fetchTarball {
    #       url = "file:///mnt/storage/Games/factorio-space-age_linux_2.0.14.tar.xz";
    #       sha256 = "sha256:047h66lp6bg92njsss0l5a9pipd9v578cxqrdf6aql54z2wsp9hq";
    #     };
    #     # mv $out/bin/.factorio-wrapped $out/bin/.factorio-space-age-wrapped
    #     # installPhase =
    #     #   prev.installPhase
    #     #   + ''
    #     #     rm $out/bin/{factorio,.factorio-wrapped}
    #     #   '';
    #   }))
  ];
}
