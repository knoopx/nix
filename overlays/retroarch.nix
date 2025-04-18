final: prev: {
  retroarch-custom = prev.retroarch.withCores (
    cores:
      with cores; [
        # beetle-pce
        # beetle-supergrafx
        # beetle-vb
        # beetle-wswan
        # bluemsx
        # bsnes
        # bsnes-hd
        # freeintv
        # fuse
        # handy
        # hatari
        # mame
        # panda3ds
        # picodrive
        # prosystem
        # stella
        beetle-ngp
        beetle-psx
        beetle-saturn
        citra
        dolphin
        dosbox-pure
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
}
