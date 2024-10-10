{
  lib,
  pkgs,
  ...
}: let
  pname = "sudachi";
  version = "1.0.11";
  src = pkgs.fetchurl {
    url = "https://github.com/emuplace/sudachi.emuplace.app/releases/download/v1.0.11/sudachi-linux-v1.0.11.7z";
    sha256 = "sha256-uR0cxnWzE82Z9tXeMcef9QUBEcYRLrbkJuXcSlrLbsI=";
  };

  runtimeDeps = with pkgs; [
    vulkan-loader
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtwebengine
    brotli
  ];
in
  pkgs.stdenv.mkDerivation
  {
    inherit pname version src;

    sourceRoot = ".";

    nativeBuildInputs = with pkgs; [
      p7zip
      qt6.wrapQtAppsHook
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m 755 -D * $out/bin
      runHook postInstall
    '';

    buildInputs = with pkgs; [
      vulkan-loader
      qt6.qtbase
    ];

    preFixup = let
      libPath = lib.makeLibraryPath runtimeDeps;
    in ''
      wrapQtApp $out/bin/sudachi --suffix LD_LIBRARY_PATH : "$out/lib:${libPath}"
      wrapQtApp $out/bin/sudachi-cmd --suffix LD_LIBRARY_PATH : "$out/lib:${libPath}"
      wrapQtApp $out/bin/sudachi-room --suffix LD_LIBRARY_PATH : "$out/lib:${libPath}"
    '';
  }
