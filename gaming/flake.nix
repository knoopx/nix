{
  description = "kOS-gaming";

  inputs = {
    launchbox-metadata.url = "http://gamesdb.launchbox-app.com/Metadata.zip";
    launchbox-metadata.flake = false;

    libretro-database.url = "github:libretro/libretro-database";
    libretro-database.flake = false;

    libretro-fbneo.url = "github:libretro/FBNeo?dir=dats";
    libretro-fbneo.flake = false;
  };

  outputs = {...} @ inputs: {
    packages = {
    };
  };
}
