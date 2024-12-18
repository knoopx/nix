{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
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
      gdk-pixbuf
      glew110
      glib
      glibc
      # gnome2.GConf
      # gnome2.pango
      gsettings-desktop-schemas
      # gtk2
      gtk3
      gtk4
      icu
      libadwaita
      # libappindicator-gtk2
      libcaca
      libcanberra
      libcap
      # libdbusmenu-gtk2
      libdrm
      libelf
      libgcrypt
      libGL
      libidn
      # libindicator-gtk2
      libpulseaudio
      libjpeg
      libmikmod
      libnotify
      libogg
      libpng
      libpng12
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
