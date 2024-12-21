{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      # gnome2.GConf
      # gnome2.pango
      # gtk2
      # libappindicator-gtk2
      # libdbusmenu-gtk2
      # libindicator-gtk2
      acl
      alsa-lib
      atk
      attr
      bzip2
      cairo
      cups
      curl
      dbus
      dbus-glib
      expat
      ffmpeg
      flac
      fontconfig
      freeglut
      freetype
      fuse
      gdk-pixbuf
      glew110
      glib
      glibc
      gsettings-desktop-schemas
      gtk3
      gtk4
      icu
      libadwaita
      libcaca
      libcanberra
      libcap
      libdrm
      libelf
      libgcrypt
      libGL
      libidn
      libjpeg
      libmikmod
      libnotify
      libogg
      libpng
      libpng12
      libpulseaudio
      librsvg
      libsamplerate
      libsodium
      libssh
      libtheora
      libtiff
      libudev0-shim
      libusb1
      libuv
      libva
      libvdpau
      libvorbis
      libvpx
      libxkbcommon
      libxml2
      lz4
      mesa
      nspr
      nss
      openssl
      pixman
      SDL
      SDL_image
      SDL_mixer
      SDL_ttf
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf
      speex
      stdenv.cc.cc
      stdenv.cc.cc.lib
      systemd
      tbb
      util-linux
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXft
      xorg.libXi
      xorg.libXinerama
      xorg.libXmu
      xorg.libXrandr
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libxshmfence
      xorg.libXt
      xorg.libXtst
      xorg.libXxf86vm
      xz
      zlib
      zstd
    ];
  };
}
