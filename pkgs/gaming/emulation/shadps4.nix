{
  pkgs,
  stdenv,
  clang,
  cmake,
  pkg-config,
  ...
}: let
  pname = "shadps4";
  version = "6a70d080431d0d337bc10cd7234e38b382f13dff";
in
  # https://github.com/shadps4-emu/shadPS4/blob/main/.github/workflows/build.yml
  stdenv.mkDerivation {
    inherit pname version;
    src =
      fetchGit
      {
        url = "https://github.com/shadps4-emu/shadPS4.git";
        rev = version;
        submodules = true;
      };
    nativeBuildInputs = [
      clang
      cmake
      pkg-config
    ];

    buildInputs = with pkgs; [
      # alsa-lib
      # curl
      ffmpeg
      SDL2
      xorg.libX11
      xorg.libXext
      # freeimage
      # freetype
      # libgit2
      # poppler
      # pugixml
      # SDL2
    ];

    # installPhase = ''
    #   install -D ../${pname} $out/bin/${pname}
    #   install -Dm755 ../es-app/assets/org.es_de.frontend.desktop $out/share/applications/org.es_de.frontend.desktop
    #   install -Dm644 ../es-app/assets/org.es_de.frontend.svg $out/share/icons/hicolor/scalable/apps/org.es_de.frontend.svg
    #   cp -r ../resources/ $out/bin/resources/
    # '';
  }
