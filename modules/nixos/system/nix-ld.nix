{pkgs, ...}: let
  electron-deps = with pkgs; [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fuse
    glib
    gtk3
    libdrm
    libgbm
    libglvnd # libGL.so.1
    libxkbcommon
    nspr
    nss
    pango
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];

  other = with pkgs; [
    # acl
    # at-spi2-core
    # atkmm
    # attr
    # bzip2
    # curl
    # dbus-glib
    # e2fsprogs
    # ffmpeg
    # ffmpeg_6 # torchvision
    # flac
    # fontconfig
    # freeglut
    # freetype
    # fribidi
    # gdk-pixbuf
    # gdtoolkit_3
    # glew110
    # glibc
    # glibc_multi
    # gnome2.GConf
    # gnome2.pango
    # gobject-introspection
    # gsettings-desktop-schemas
    # gtk2
    # gtk4
    # harfbuzz
    # icu
    # intel-media-driver
    # intel-vaapi-driver
    # libadwaita
    # libappindicator-gtk2
    # libcaca
    # libcanberra
    # libcap
    # libdbusmenu-gtk2
    # libelf
    # libgcc.lib
    # libgcrypt
    # libGL
    # libgpg-error
    # libidn
    # libindicator-gtk2
    # libjpeg
    # libmikmod
    # libnotify
    # libogg
    # libp11
    # libpng
    # libpng12
    # libpulseaudio
    # librsvg
    # libsamplerate
    # libsodium
    # libsoup_3
    # libssh
    # libthai
    # libtheora
    # libtiff
    # libudev0-shim
    # libusb1
    # libuv
    # libva
    # libvdpau
    # libvorbis
    # libvpx
    # libxml2
    # lz4
    # mesa
    # nvidia-vaapi-driver
    # openssl
    # pipewire
    # pixman
    # SDL
    # SDL_image
    # SDL_mixer
    # SDL_ttf
    # SDL2
    # SDL2_image
    # SDL2_mixer
    # SDL2_ttf
    # speex
    # stdenv.cc.cc
    # stdenv.cc.cc.lib
    # systemd
    # tbb
    # util-linux
    # wayland
    # webkitgtk_4_1
    # xorg.libICE
    # xorg.libSM
    # xorg.libX11
    # xorg.libXcursor
    # xorg.libXft
    # xorg.libXi
    # xorg.libXinerama
    # xorg.libXmu
    # xorg.libXrender
    # xorg.libXScrnSaver
    # xorg.libxshmfence
    # xorg.libXt
    # xorg.libXtst
    # xorg.libXxf86vm
    # xz
    # zlib
    # zstd
  ];
in {
  programs.nix-ld = {
    enable = true;
    libraries = electron-deps;
  };
}
