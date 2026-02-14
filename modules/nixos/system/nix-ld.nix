{pkgs, ...}: let
  electron-deps = with pkgs; [
    alsa-lib
    asar
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fuse
    glib
    glib.dev
    gtk3
    libdrm
    libgbm
    libglvnd # libGL.so.1
    libxkbcommon
    nspr
    nss
    pango
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
  ];

  gtk-dev = with pkgs; [
    glib-networking
    gobject-introspection
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk3
    gtk4
    gtksourceview5
    pango
    gobject-introspection
    cairo
    gdk-pixbuf
    libadwaita
    libhandy
    webkitgtk_6_0
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
    ffmpeg
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
    libusb1
    libclang
    # libuv
    # libva
    # libvdpau
    # libvorbis
    # libvpx
    # libxml2
    # lz4
    # mesa
    # nvidia-vaapi-driver
    openssl
    # pipewire
    # pixman
    # SDL
    # SDL_image
    # SDL_mixer
    # SDL_ttf
    SDL2
    # SDL2_image
    # SDL2_mixer
    # SDL2_ttf
    # speex
    # stdenv.cc.cc
    # stdenv.cc.cc.lib
    # systemd
    # tbb
    # util-linux
    wayland
    webkitgtk_4_1
    # libice
    # libsm
    # libx11
    # libxcursor
    # libxft
    # libxi
    # libxinerama
    # libxmu
    # libxrender
    # libxscrnsaver
    # libxshmfence
    # libxt
    # libxtst
    # libxxf86vm
    # xz
    # zlib
    # zstd
  ];
in {
  programs.nix-ld = {
    enable = true;
    libraries = electron-deps ++ gtk-dev ++ other;
  };
}
