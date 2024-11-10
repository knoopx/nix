{
  pkgs,
  stdenvNoCC,
  unzip,
  makeWrapper,
  autoPatchelfHook,
  SDL2,
  SDL2_mixer,
  makeDesktopItem,
  ...
}: let
  name = "World of Goo";
  pname = "worldofgoo";
in
  stdenvNoCC.mkDerivation rec {
    inherit name pname;

    libPath = with pkgs; [
      stdenv.cc.cc.lib
      stdenv.cc.libc
      SDL2
      SDL2_mixer
      libogg
      libvorbis
      pango
      cairo
      gdk-pixbuf
      gtk2-x11
    ];

    src = fetchTree {
      type = "file";
      url = "file:///mnt/storage/Games/GOG/world_of_goo_1_51_29337.sh";
      narHash = "sha256-Rzroec+PN7ytJctfYCbSpogHudo+etKxf+1KhU0h3bw=";
    };

    sourceRoot = ".";

    nativeBuildInputs =
      [
        unzip
        makeWrapper
        autoPatchelfHook
      ]
      ++ libPath;

    unpackCmd = "unzip $src -d . || true";

    desktopItem = makeDesktopItem {
      desktopName = name;
      exec = pname;
      icon = pname;
      name = pname;
      categories = ["Game"];
    };

    installPhase = ''
      mkdir -p $out/{bin,share/${pname}}
      rm data/noarch/game/WorldOfGoo.bin.x86
      cp -r * $out/share/${pname}
      install -D $out/share/${pname}/data/noarch/game/game/gooicon.png $out/share/pixmaps/${pname}.png
      install -D ${desktopItem}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
      ln -s $out/share/${pname}/data/noarch/game/WorldOfGoo.bin.x86_64 $out/bin/${pname}
    '';
  }
