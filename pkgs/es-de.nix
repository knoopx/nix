{
  lib,
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
  ...
}:
stdenv.mkDerivation {
  pname = "es-de";
  version = "3.0.3";

  src = fetchzip {
    url = "https://gitlab.com/es-de/emulationstation-de/-/archive/v3.0.3/emulationstation-de-v3.0.3.tar.gz";
    hash = "";
  };

  # patches = [./001-add-nixpkgs-retroarch-cores.patch];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    # alsa-lib
    # curl
    # ffmpeg
    # freeimage
    # freetype
    # libgit2
    # poppler
    # pugixml
    # SDL2
  ];

  installPhase = ''
    install -D ../emulationstation $out/bin/emulationstation
    cp -r ../resources/ $out/bin/resources/
  '';

  meta = {
    description = "EmulationStation Desktop Edition is a frontend for browsing and launching games from your multi-platform game collection.";
    homepage = "https://es-de.org";
    maintainers = with lib.maintainers; [ivarmedi];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "emulationstation";
  };
}
