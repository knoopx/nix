{
  lib,
  stdenvNoCC,
  unzip,
  makeWrapper,
  makeBinaryWrapper,
  autoPatchelfHook,
  SDL2,
  SDL2_mixer,
  ...
}
: let
  commonDeps = [
    SDL2
    SDL2_mixer
  ];
in
  stdenvNoCC.mkDerivation rec {
    name = "worldofgoo";
    src = fetchTree {
      type = "file";
      url = "file:///mnt/storage/Games/GOG/world_of_goo_1_51_29337.sh";
      narHash = "sha256-Rzroec+PN7ytJctfYCbSpogHudo+etKxf+1KhU0h3bw=";
      # url = "file:///mnt/storage/Games/GOG/world_of_goo_2_v1.0.12478.run";
      # narHash = "sha256-G5lNM0ZsEZS8P5+Gx46p4/m4JLjNZeia7dXopO667HQ=";
    };

    nativeBuildInputs =
      [
        unzip
        # makeWrapper
        makeBinaryWrapper
        autoPatchelfHook
      ]
      ++ commonDeps;

    dontUnpack = true;

    buildPhase = ''
      unzip $src -d . || true
      mkdir -p $out/bin
      # cp data/noarch/game/WorldOfGoo.bin.x86_64 $out/bin/${name}
    '';

    installPhase = ''
      makeBinaryWrapper data/noarch/game/WorldOfGoo.bin.x86_64 $out/bin/${name} --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath commonDeps}
    '';
  }
