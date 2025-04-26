{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      # gdtoolkit_3
      # gnome2.GConf
      # gnome2.pango
      # gtk2
      # libappindicator-gtk2
      # libdbusmenu-gtk2
      # libindicator-gtk2
      acl
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      atkmm
      attr
      bzip2
      cairo
      cups
      curl
      dbus
      dbus-glib
      expat
      ffmpeg
      ffmpeg_6 # torchvision
      flac
      fontconfig
      freeglut
      freetype
      fuse
      gdk-pixbuf
      glew110
      glib
      glibc
      glibc_multi
      gobject-introspection
      gsettings-desktop-schemas
      gtk3
      gtk4
      harfbuzz
      icu
      libadwaita
      libcaca
      libcanberra
      libcap
      libdrm
      libelf
      libgcc.lib
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
      libsoup_3
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
      pango
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
      webkitgtk_4_1
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
