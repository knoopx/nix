{pkgs, ...}: let
in {
  home.file.".local/share/dats/fbneo" = {
    source = pkgs.stdenvNoCC.mkDerivation {
      name = "libretro-fbneo-database";
      phases = ["installPhase"];
      installPhase = ''
        ln -s $src/dats $out
      '';
      src = pkgs.fetchFromGitHub {
        owner = "libretro";
        repo = "FBNeo";
        rev = "27f594be691e7a7fbb9db9d4a5d0dc12219e4fa4";
        hash = "sha256-BjsEghQvaGyA+zjt7mWv8L6UBvIlW1GDgApEwdKiD2o=";
      };
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
      src = pkgs.fetchFromGitHub {
        owner = "libretro";
        repo = "libretro-database";
        rev = "49acc074cc09d1b9a1bfb67e5c490b10c443ff89";
        hash = "sha256-oZFuwBTOffmBTYKn9LSfIulR5gjOZ1gJIkJcgRH2ezg=";
      };
    };
  };
}
