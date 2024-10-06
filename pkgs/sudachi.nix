{
  lib,
  pkgs,
  ...
}: let
  pname = "sudachi";
  version = "1.0.10";
  src = pkgs.fetchurl {
    url = "https://github.com/emuplace/sudachi.emuplace.app/releases/download/v1.0.10/sudachi-linux-v1.0.10.7z";
    sha256 = "sha256-XVDedGj32Cze5TchCgj/A1pIaUkpd3CzaqCzOwcb02U=";
  };
in
  pkgs.stdenv.mkDerivation
  {
    inherit pname version src;

    sourceRoot = ".";

    nativeBuildInputs = with pkgs; [
      p7zip
      qt5.wrapQtAppsHook
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m 755 -D * $out/bin
      runHook postInstall
    '';

    preFixup = let
      libPath = lib.makeLibraryPath [
        pkgs.vulkan-loader
        pkgs.qt5.qtbase
        pkgs.qt5.qtmultimedia
        pkgs.qt5.qtwebengine
        pkgs.brotli
      ];
    in ''
      wrapQtApp $out/bin/sudachi --suffix LD_LIBRARY_PATH : "$out/lib:${libPath}"
      wrapQtApp $out/bin/sudachi-cmd --suffix LD_LIBRARY_PATH : "$out/lib:${libPath}"
      wrapQtApp $out/bin/sudachi-room --suffix LD_LIBRARY_PATH : "$out/lib:${libPath}"
    '';
  }
