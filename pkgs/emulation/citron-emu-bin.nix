{pkgs, ...}:
pkgs.stdenvNoCC.mkDerivation
rec {
  pname = "citron-emu";
  version = "nightly-20241208_091045";
  src = fetchTarball {
    url = "https://git.citron-emu.org/Citron/Citron/releases/download/${version}/Citron-Linux.tar.gz";
    sha256 = "sha256:0154a55ay95cqh81h41293kxrqx6hfqg4bnlb0m9cf1yic8lb387";
  };
  # sourceRoot = ".";
  # nativeBuildInputs = with pkgs; [
  #   gzip
  # ];
  runtimeLibs = with pkgs; [
    qt5.qtbase

    # libGL
    # libGLU
    # libevent
    # libffi
    # libjpeg
    # libpng
    # libstartup_notification
    # libvpx
    # libwebp
    SDL2

    # git
    #   vulkan-headers
    #   vulkan-utility-libraries
    #   boost185
    #   autoconf
    #   fmt
    #   llvm_19
    #   nasm
    #   lz4
    #   nlohmann_json
    # ffmpeg
    # #   qt6.qtbase
    # #   enet
    # libva
    # #   vcpkg
    # #   libopus
    # #   udev

    # stdenv.cc.cc

    # fontconfig
    # libxkbcommon
    # zlib
    # freetype
    # gtk3
    # libxml2
    # dbus
    # xcb-util-cursor
    # alsa-lib
    # libpulseaudio
    # pango
    # atk
    # cairo
    # gdk-pixbuf
    # glib
    # udev
    # libva
    # mesa
    # libnotify
    # cups
    # pciutils
    # ffmpeg
    # libglvnd
    # pipewire
  ];
  # ++ (with pkgs.xorg; [
  #   libxcb
  #   libX11
  #   libXcursor
  #   libXrandr
  #   libXi
  #   libXext
  #   libXcomposite
  #   libXdamage
  #   libXfixes
  #   libXScrnSaver
  # ]);

  nativeBuildInputs = with pkgs;
    [
      autoPatchelfHook
      kdePackages.wrapQtAppsHook

      # makeWrapper
      # copyDesktopItems
      # wrapGAppsHook
    ]
    ++ runtimeLibs;

  installPhase = ''
    install -Dm755 $src/citron $out/bin/${pname}
  '';
}
