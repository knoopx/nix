{
  lib,
  stdenv,
  autoPatchelfHook,
  copyDesktopItems,
  lrzip,
  makeWrapper,
  gcc-unwrapped,
  zlib,
  libGL,
  xorg,
  alsa-lib,
  libudev0-shim,
  makeDesktopItem,
}: let
  pname = "liftoff";
  version = "";

  desktopItem = makeDesktopItem {
    name = "Liftoff";
    desktopName = "Liftoff";
    exec = pname;
    icon = pname;
  };
in
  stdenv.mkDerivation rec {
    inherit pname version;

    src = fetchTarball {
      url = "file:///mnt/storage/Games/liftoff-linux.tar.lrz";
      sha256 = "";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      lrzip
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      # gcc-unwrapped.lib
      # zlib
    ];

    libPath = "$out/share/${pname}/lib64";
    libPathExtra = lib.makeLibraryPath [
      libGL
      # xorg.libXinerama
      # alsa-lib
      # libudev0-shim
    ];

    installPhase = ''
      mkdir -p $out/share/${pname} $out/bin $out/share
      mv * $out/share/${pname}
      cp -r ${desktopItem}/share/* $out/share/
      makeWrapper $out/share/${pname}/Liftoff.x86_64 $out/bin/${pname} --prefix LD_LIBRARY_PATH : "${libPath}:${libPathExtra}"
    '';
  }
