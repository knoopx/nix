final: prev: {
  retroarch-custom = prev.retroarch.withCores (
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
        # freeintv
        # fuse
        # handy
        # hatari
        # mame
        # mupen64plus
        # panda3ds
        # picodrive
        # prosystem
        # stella
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
        pcsx2
        ppsspp
        puae
        snes9x
      ]
  );
}
