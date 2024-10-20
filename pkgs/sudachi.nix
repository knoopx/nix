{
  lib,
  pkgs,
  ...
}: let
  pname = "sudachi";
  version = "1.0.11";
  src = pkgs.fetchurl {
    url = "https://github.com/emuplace/sudachi.emuplace.app/releases/download/v${version}/sudachi-linux-v${version}.7z";
    sha256 = "sha256-TCnO+rFW6ZTau6egcnsPNW5vweb6H1GABDuOW69GixQ=";
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
      git
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
