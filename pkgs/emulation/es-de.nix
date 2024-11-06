{
  pkgs,
  stdenv,
  cmake,
  fetchzip,
  pkg-config,
  alsa-lib,
  curl,
  ffmpeg,
  freeimage,
  freetype,
  libgit2,
  poppler,
  pugixml,
  SDL2,
  nix-update-script,
  fetchFromGitLab,
  ...
}: let
  pname = "es-de";
  version = "3.1.0";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitLab {
      owner = "es-de";
      repo = "emulationstation-de";
      rev = version;
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      alsa-lib
      curl
      ffmpeg
      freeimage
      freetype
      libgit2
      poppler
      pugixml
      SDL2
    ];

    installPhase = ''
      install -D ../${pname} $out/bin/${pname}
      install -Dm755 ../es-app/assets/org.es_de.frontend.desktop $out/share/applications/org.es_de.frontend.desktop
      install -Dm644 ../es-app/assets/org.es_de.frontend.svg $out/share/icons/hicolor/scalable/apps/org.es_de.frontend.svg
      cp -r ../resources/ $out/bin/resources/
    '';

    passthru.updateScript = nix-update-script {};
  }
