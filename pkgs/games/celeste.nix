{
  lib,
  stdenvNoCC,
  autoPatchelfHook,
  copyDesktopItems,
  unzip,
  makeWrapper,
  gcc-unwrapped,
  zlib,
  libGL,
  xorg,
  alsa-lib,
  libudev0-shim,
  makeDesktopItem,
}: let
  pname = "celeste";
  version = "1.4.0.0";

  desktopItem = makeDesktopItem {
    desktopName = "Celeste";
    name = pname;
    exec = pname;
    icon = pname;
  };
in
  stdenvNoCC.mkDerivation rec {
    inherit pname version;

    src = fetchTree {
      type = "file";
      url = "file:///mnt/storage/Games/celeste-linux-${version}.zip";
      narHash = "sha256-DIFwuQekbeSIth0wV7+EDzDlonKbgwHmujjpQwOIPFM=";
    };

    sourceRoot = ".";

    unpackCmd = "unzip $src -d .";

    nativeBuildInputs = [
      unzip
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      gcc-unwrapped.lib
      zlib
    ];

    libPath = "$out/share/${pname}/lib64";
    libPathExtra = lib.makeLibraryPath [
      libGL
      xorg.libXinerama
      alsa-lib
      libudev0-shim
    ];

    installPhase = ''
      mkdir -p $out/share/${pname} $out/bin $out/share
      mv * $out/share/${pname}
      cp -r ${desktopItem}/share/* $out/share/
      install -m 444 -D $out/share/${pname}/Celeste.png $out/share/pixmaps/${pname}.png
      makeWrapper $out/share/${pname}/Celeste.bin.x86_64 $out/bin/${pname} --prefix LD_LIBRARY_PATH : "${libPath}:${libPathExtra}"
    '';
  }
