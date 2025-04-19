{
  pkgs,
  launchbox-metadata,
  libretro-database,
  libretro-fbneo,
  ...
}: let
in {
  home.file.".local/share/dats/fbneo" = {
    source = pkgs.stdenvNoCC.mkDerivation {
      name = "libretro-fbneo-database";
      phases = ["installPhase"];
      installPhase = ''
        ln -s $src $out
      '';
      src = libretro-fbneo;
    };
  };

  home.file.".local/share/dats/libretro" = {
    source = pkgs.stdenvNoCC.mkDerivation {
      name = "libretro-database";
      phases = ["installPhase"];
      installPhase = ''
        mkdir -p $out
        cp -r $src/{dat,metadat}/ $out
      '';
      src = libretro-database;
    };
  };

  home.file.".local/share/launchbox" = {
    source = pkgs.stdenvNoCC.mkDerivation {
      name = "launchbox-metadata";
      installPhase = ''
        mkdir -p $out
        cp -r *.xml $out
      '';
      src = launchbox-metadata;
    };
  };
}
