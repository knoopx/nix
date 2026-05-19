{pkgs}: let
  pname = "tolaria";
  version = "2026.5.21";
  releaseTag = "v2026-05-21";

  src = pkgs.fetchurl {
    url = "https://github.com/refactoringhq/tolaria/releases/download/${releaseTag}/Tolaria_${version}_amd64.deb";
    hash = "sha256-mzi7EZwr0yzkERw4v3lLqjXNImLPyK/+sH29G8gHX5U=";
  };

  inherit (pkgs) lib stdenv;

  # Runtime libraries needed by the bundled binary
  gst = pkgs.gst_all_1;
  runtimeDeps = with pkgs; [
    alsa-lib
    at-spi2-core
    atk
    cairo
    dbus
    egl-wayland
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gst.gstreamer
    gst.gst-plugins-base
    gtk3
    harfbuzz
    icu
    libdrm
    libepoxy
    libglvnd
    libpng
    libsoup_3
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    mesa
    nspr
    nss
    pango
    pipewire
    wayland
    webkitgtk_4_1
    libxcb
  ];

  rpath = lib.makeLibraryPath runtimeDeps;
in
  stdenv.mkDerivation {
    inherit pname version src;

    unpackPhase = "ar x $src && gzip -d < data.tar.gz | tar xf -";

    dontBuild = true;

    nativeBuildInputs = [
      pkgs.wrapGAppsHook4
      pkgs.gtk3 # needed for GSETTINGS_SCHEMAS_PATH
    ];

    dontWrapGApps = true;

    installPhase = ''
      mkdir -p $out/bin
      cp -a usr/bin/tolaria $out/bin/tolaria

      mkdir -p $out/lib/Tolaria
      cp -a usr/lib/Tolaria/. $out/lib/Tolaria/

      mkdir -p $out/share/applications
      install -Dm644 usr/share/applications/Tolaria.desktop \
        $out/share/applications/Tolaria.desktop

      mkdir -p $out/share/icons/hicolor/128x128/apps
      install -Dm644 usr/share/icons/hicolor/128x128/apps/tolaria.png \
        $out/share/icons/hicolor/128x128/apps/tolaria.png

      mkdir -p $out/share/icons/hicolor/32x32/apps
      install -Dm644 usr/share/icons/hicolor/32x32/apps/tolaria.png \
        $out/share/icons/hicolor/32x32/apps/tolaria.png

      mkdir -p $out/share/icons/hicolor/256x256@2/apps
      install -Dm644 usr/share/icons/hicolor/256x256@2/apps/tolaria.png \
        $out/share/icons/hicolor/256x256@2/apps/tolaria.png
    '';

    postFixup = ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeDeps}
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${gst.gstreamer}/lib/gstreamer-1.0:${gst.gst-plugins-base}/lib/gstreamer-1.0"
      )
      wrapGApp $out/bin/tolaria
    '';

    meta = {
      description = "Desktop app for managing markdown knowledge bases";
      homepage = "https://github.com/refactoringhq/tolaria";
      license = lib.licenses.agpl3Plus;
      platforms = ["x86_64-linux"];
      mainProgram = "tolaria";
      maintainers = [];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  }
